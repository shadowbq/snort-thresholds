module Threshold

  class InvalidThresholdsObject < StandardError; end
  class ReadOnlyThresholdFile < StandardError; end
  class NonExistantThresholdFile < StandardError; end
  class MissingThresholdFileConfiguration < StandardError; end
  class ThresholdAtomicLockFailure < StandardError; end

  class Thresholds < Array

    attr_accessor :file, :readonly

    # Write changes to the file
    def flush
      begin 
        valid_existing_file?(@file)
        raise ReadOnlyThresholdsFile if @readonly
        hash = current_hash
        
        file = File.open(@file, 'w+')
        raise ThresholdAtomicLockFailure, 'The @file state/hash changed before we could flush the file' unless stored_hash == hash
        file.write self.sort.to_s
        file.close

      rescue NonExistantThresholdFile
        raise ReadOnlyThresholdsFile if @readonly

        file = File.open(@file, 'w')
        file.write self.sort.to_s
        file.close
      end
      return true 
    end

    # Clears current collection and Read in the thresholds.conf file 
    def loadfile!
      self.clear
      loadfile
    end

    # Append in the thresholds.conf file to current collection
    def loadfile
      valid_existing_file?(@file)

      results = Threshold::Parser.new(@file)
      @stored_hash= results.filehash
      #puts stored_hash
      results.caps.each do |result|
         builder = Threshold::Builder.new(result)
         self << builder.build
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

      raise InvalidThresholdsObject, "Container object has unknown objects" unless valid?

      self.each do |threshold|
        output << threshold.to_s + "\n"
      end
      return output
    end

    def stored_hash
      @stored_hash
    end

    private

    def stored_hash=(foo)
      @stored_hash=foo
    end

    def current_hash
      file = File.open(@file, 'rb+') 
      file.flock(File::LOCK_EX)
      hash = Digest::MD5.file @file
      file.close
      return hash
    end

    def valid_existing_file?(file)
      if file !=nil
        raise NonExistantThresholdFile, "Missing threshold.conf" unless (File.file?(file) and File.exists?(file))
      else
        raise MissingThresholdFileConfiguration, "Missing threshold.conf path. See README for Usage."
      end
      return true
    end


  end
end