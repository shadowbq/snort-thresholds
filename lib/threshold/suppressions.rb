module Threshold

  class InvalidSuppressionsObject < StandardError; end

  class Suppressions < Array
    def valid?
      begin 
        self.each do |suppression| 
          if suppression.respond_to?(:valid?)
            return false unless suppression.valid?
          else
            raise InvalidSuppressionsObject, "Container object has unknown objects"
          end
        end
        return true
      rescue InvalidSuppressionsObject
        return false
      end
    end

    def sort
      raise InvalidSuppressionsObject unless valid?
      super
    end

    def to_s
      output = ""
      self.each do |suppression|
        output << suppression.to_s + "\n"
      end
      return output
    end

  end
end