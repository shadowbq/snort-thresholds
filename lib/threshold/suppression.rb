
# suppress \
#     gen_id <gid>, sig_id <sid>
# 
# suppress \
#     gen_id <gid>, sig_id <sid>, \
#     track by_src|by_dst, \
#     ip <ip-list>
#   Note: ip can be 1.2.3.4 or 1.2.4.5/32

# Create a Standard Error Wrapper

module Threshold

  class InvalidSuppressionObject < StandardError; end

  # Create a Suppression validator
  class SuppressionValidator
      include Veto.validator

      validates :gid, :presence => true, :integer => true
      validates :sid, :presence => true, :integer => true

      validates :track_by, :presence => true, :if => :ip_set?, :inclusion => ['src', 'dst']
      validates :ip, :presence => true, :if => :track_by_set?, :format => /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]).){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/([0-9]|[1-2][0-9]|3[0-2]))?$/

      def track_by_set?(entity)
          entity.track_by
      end

      def ip_set?(entity)
          entity.ip
      end
  end

  class Suppression 

  	attr_accessor :gid, :sid, :track_by, :ip, :comment

  	def to_s
      if self.valid?
    		if track_by == nil then
    		  "suppress gen_id #{@gid}, sig_id #{@sid}"
    		else  
    		  "suppress gen_id #{@gid}, sig_id #{@sid}, track by_#{@track_by}, ip #{@ip}"
    		end
      else
        raise InvalidSuppressionObject, 'Object did not validate'
      end
  	end

    def valid?
      validator = SuppressionValidator.new
      return validator.valid?(self)
    end

  end

end