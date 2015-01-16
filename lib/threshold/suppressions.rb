module Threshold

  class InvalidSuppressionsObject < StandardError; end
  class ReadOnlyThresholdFile < StandardError; end
  class MissingThresholdFile < StandardError; end
  class ThresholdAtomicLockFailure < StandardError; end

  class Suppressions < Array

    attr_accessor :file, :readonly

    def flush
      raise ReadOnlySuppressionsFile if @readonly
      ## Did the file change?
      if locked_filehash == current_filehash
        file = File.open(@file, 'w') 
        file.write self.to_s
        file.close
      else
        raise ThresholdAtomicLockFailure, 'The @file state/hash changed before we could flush the file'
      end
    end

    #Kinda sortof not really
    def loadfile
        raise MissingThresholdFile "Missing threshold.conf" unless (File.file?(@file) and File.exists?(@file))
        File.readlines(@file) do |line| 
          suppression = Suppression.new(line)
          self.push(suppression) 
        end
    end

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

    # This should transpose? back to a Suppressions class not return as an Array. (super)
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

    private



    def locked_filehash
      #@locked_filehash
      11111
    end

    def current_filehash
      11111
    end


  end
end