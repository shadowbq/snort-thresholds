module Threshold
  module Standalone

    # Handle Comment Skipping
    def comment?(skip)
      if skip
        return false
      else
        if defined?(@comment)
          return true
        else
          return false
        end  
      end
    end

    # Equality Methods
    def ==(an0ther)
      an0ther.class == self.class && an0ther.hash == hash
    end

    alias_method :eql?, :==

    def hash
      state.hash
    end

    #Comparable
    def <=>(anOther)
      #gid <=> anOther.gid
      c = self.class.to_s <=> anOther.class.to_s
      if c == 0 then 
        d = self.gid <=> anOther.gid
        if d == 0 then
          self.sid <=> anOther.sid
        else
          return d
        end   
      else
        return c
      end
    end

  end
end