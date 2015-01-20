module Threshold

  class InvalidThresholdsObject < StandardError; end
  class ReadOnlyThresholdFile < StandardError; end
  class MissingThresholdFile < StandardError; end
  class ThresholdAtomicLockFailure < StandardError; end

  class Thresholds < Array

    attr_accessor :file, :readonly

    def flush
      raise ReadOnlyThresholdsFile if @readonly
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
          # JANKY>>>>
          threshold = Suppression.new(line)
          self.push(threshold) 
        end
    end

    def valid?
      begin 
        self.each do |threshold| 
          if threshold.respond_to?(:valid?)
            return false unless threshold.valid?
          else
            raise InvalidThresholdsObject, "Container object has unknown objects"
          end
        end
        return true
      rescue InvalidThresholdsObject
        return false
      end
    end

    # This should transpose? back to a Thresholds class not return as an Array. (super)
    def sort
      raise InvalidThresholdsObject unless valid?
      new_temp = super
      temp = Thresholds.new
      new_temp.each {|item| temp << item}
      return temp
    end

    def sort!
      raise InvalidThresholdsObject unless valid?
      super
    end

    def to_s
      output = ""
      self.each do |threshold|
        output << threshold.to_s + "\n"
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