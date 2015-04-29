# rate_filter provides rate based attack prevention by allowing users to
# configure a new action to take for a specified time when a given rate is
# exceeded.  Multiple rate filters can be defined on the same rule, in which case
# they are evaluated in the order they appear in the configuration file, and the
# first applicable action is taken.  

# Rate filters are used as standalone commands (outside any rule) and have the
# following format:

# rate_filter \
#     gen_id <gid>, sig_id <sid>, \
#     track <by_src|by_dst|by_rule>, \
#     count <c>, seconds <s>, \
#     new_action alert|drop|pass|log|sdrop|reject, \
#     timeout <seconds>, \
#     apply_to <ip-list>

# This format has the following options - all are required except apply_to, which
# is optional:

# * Track by_src|by_dst|by_rule:  rate is tracked either by source IP address,
#   destination IP address, or by rule.  This means the match statistics are
#   maintained for each unique source IP address, for each unique destination IP
#   address, or they are aggregated at rule level.  For rules related to Stream5
#   sessions, source and destination means client and server respectively.  track
#   by_rule and apply_to may not be used together.

# * Count c:  the maximum number of rule matches in s seconds before the rate
#   filter limit to is exceeded.  C must be positive.

# * seconds s:  the time period over which count is accrued. 0 seconds means
#   count is a total count instead of a specific rate.  For example, rate filter
#   may be used to detect if the number of connections to a specific server
#   exceed a specific count.  0 seconds only applies to internal rules (gen_id 135)
#   and other use will produce a fatal error by Snort.

# * new_action <alert|drop|pass|log|sdrop|reject>:  new_action replaces rule
#   action with alert|drop| pass|log|sdrop for r (timeout) seconds.  Drop, reject
#   and sdrop can be used only when snort is used in inline mode.  sdrop and
#   reject are conditionally compiled with #ifdef GIDS.

# * timeout r:  revert to the original rule action after r seconds.  If r is 0,
#   then rule action is never reverted back.  Event filter may be used to manage
#   number of alerts after the rule action is enabled by rate filter.

# * apply_to <ip-list>:  restrict the configuration to only to source or
#   destination IP address (indicated by track parameter) determined by
#   <ip-list>.  track by_rule and apply_to may not be used together.  Note that
#   events are generated during the timeout period, even if the rate falls below
#   the configured limit.  


# Example - allow a maximum of 100 connection attempts per second from any one
# IP address, and block further connection attempts from that IP address for 10
# seconds:

# rate_filter \
#     gen_id 135, sig_id 1, \
#     track by_src, \
#     count 100, seconds 1, \
#     new_action drop, timeout 10


# Create a Standard Error Wrapper

module Threshold

  class InvalidRateFilterObject < StandardError; end

  # Create a Rate Filter validator
  class RateFilterValidator
      include Veto.validator

      validates :gid, :presence => true, :integer => true
      validates :sid, :presence => true, :integer => true
      validates :track_by, :presence =>true, :inclusion => ['src', 'dst', 'rule']
      validates :count, :presence => true, :integer => true
      validates :seconds, :presence => true, :integer => true
      validates :new_action, :presence => true, :inclusion => ['alert', 'drop', 'pass', 'log', 'sdrop', 'reject']
      validates :timeout, :presence => true, :integer => true
      validates :apply_to, :if => :not_track_by_rule?, :format => /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]).){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/([1-9]|[1-2][0-9]|3[0-2]))?$/
      validates :comment, :if => :comment_set?, :format => /^\s*#.*/

      def comment_set?(entity)
          entity.comment
      end

      def not_track_by_rule?(entity)
        if entity.apply_to == nil
          entity.track_by == false
        else
          entity.track_by != 'rule'
      end
    end

  end

  class RateFilter 

  	attr_accessor :gid, :sid, :track_by, :count, :seconds, :new_action, :timeout, :apply_to, :comment

    include Veto.model(RateFilterValidator.new)
    include Comparable
    include Threshold::Standalone

    def initialize(line="")
      transform(line) unless line.empty?
    end

  	def to_s(skip = false)

      if self.valid? 
         if apply_to == nil then
           if comment?(skip)
            "rate_filter gen_id #{@gid}, sig_id #{@sid}, track by_#{@track_by}, count #{@count}, seconds #{@seconds}, new_action #{@new_action}, timeout #{@timeout}#{@comment}"
           else
            "rate_filter gen_id #{@gid}, sig_id #{@sid}, track by_#{@track_by}, count #{@count}, seconds #{@seconds}, new_action #{@new_action}, timeout #{@timeout}"
           end  
         else
           if comment?(skip)
            "rate_filter gen_id #{@gid}, sig_id #{@sid}, count #{@count}, seconds #{@seconds}, new_action #{@new_action}, timeout #{@timeout} apply_to #{@apply_to}#{@comment}"
           else
            "rate_filter gen_id #{@gid}, sig_id #{@sid}, count #{@count}, seconds #{@seconds}, new_action #{@new_action}, timeout #{@timeout} apply_to #{@apply_to}"
           end 
         end 
      else
        raise InvalidRateFilterObject, 'Rate Filter did not validate'
      end
  	end
    
    #State does not track comments
    def state
      [@gid, @sid, @track_by, @count, @seconds, @new_action, @timeout, @apply_to]
    end

    private

    def transform(result)
      begin 
        self.gid = result["GID"].compact.first.to_i
        self.sid = result["SID"].compact.first.to_i
        self.track_by = result["TRACK"].compact.first.split('_')[1]

        self.count = result["COUNT"].compact.first.to_i
        self.seconds = result["SECONDS"].compact.first.to_i
        self.timeout = result["TIMEOUT"].compact.first.to_i
        self.new_action = result["NEW_ACTION"].compact.first

        if result.key("IPCIDR")
          self.apply_to = result["IPCIDR"].compact.first
        end
        if result.key?("COMMENT")
          self.comment = result["COMMENT"].compact.first.chomp
        end
        raise InvalidRateFilterObject unless self.valid?
      rescue
        raise InvalidRateFilterObject, 'Failed transformation from parser'
      end
    end

  end

end
