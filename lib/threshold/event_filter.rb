
# In Snort 2.8.5, a new command event_filter was added with the following format.
# It functions the same as the global threshold command does in Snort 2.8.4 and
# earlier, except that it is not permitted within a rule.

# event_filter \
#     gen_id <gid>, sig_id <sid>, \
#     type <limit|threshold|both>, \
#     track <by_src|by_dst>, \
#     count <c>, seconds <s>

# This format supports the following options - all are required:

# * gen_id, sig_id:  specify generator and signature ids of an associated rule.  A
#   sig_id of 0 will apply to all sig_ids for the given gen_id.  If both gen_id
#   and sig_id are zero, the event_filter applies to all events.  Only one
#   event_filter may be defined for a given gen_id, sig_id.

# * type <limit|threshold|both>:  type limit alerts on the 1st m events during the
#   time interval, then ignores events for the rest of the time interval.  Type
#   threshold alerts every m times we see this event during the time interval.
#   Type both alerts once per time interval after seeing m occurrences of the
#   event, then ignores any additional events during the time interval.

# * track by_src|by_dst:  rate is tracked either by source IP address, or
#   destination IP address.  This means count is maintained at either by unique
#   source IP addresses, or unique destination IP addresses.

# * count c:  number of rule matching in s seconds that will cause event filter
#   limit to exceed.  C must be nonzero value.  A count of -1 disables the
#   event filter and can be used to override the global event_filter.

# * seconds s:  time period over which count is accrued.  S must be nonzero value.=end

# Example - rule event_filter - limit to logging 1 event per 60 seconds:

# event_filter \
#     gen_id 1, sig_id 1851, \
#     type limit, track by_src, \
#     count 1, seconds 60


# Create a Standard Error Wrapper

module Threshold

  class InvalidEventFilterObject < StandardError; end

  # Create an Event Filter validator
  class EventFilterValidator
      include Veto.validator

      validates :gid, :presence => true, :integer => true
      validates :sid, :presence => true, :integer => true
      validates :type, :presence => true,  :inclusion => ['limit', 'threshold', 'both']
      validates :track_by, :presence => true, :inclusion => ['src', 'dst']
      validates :count, :presence => true, :integer => true
      validates :seconds, :presence => true, :integer => true
      

      def track_by_set?(entity)
          entity.track_by
      end

      def type_set?(type)
          entity.type
      end
  end

  class EventFilter 

  	attr_accessor :gid, :sid, :type, :track_by, :count, :seconds, :comment

  	def to_s
      if self.valid? 
        if defined?(@comment) 
          if @comment.length > 1
      		  "event_filter gen_id #{@gid}, sig_id #{@sid}, type #{@type}, track by_#{@track_by}, count #{@count}, seconds #{@seconds} #{@comment}"
          end  
        else
          "event_filter gen_id #{@gid}, sig_id #{@sid}, type #{@type}, track by_#{@track_by}, count #{@count}, seconds #{@seconds}" 
        end
      else
        raise InvalidEventFilterObject, 'Event Filter did not validate'
      end
  	end

    def valid?
      validator = EventFilterValidator.new
      return validator.valid?(self)
    end

  end

end