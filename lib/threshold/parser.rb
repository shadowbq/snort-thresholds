module Threshold
  
  #Returns an Array of Grok Captures from the input file matching Threshold Conf standards
  class Parser

    attr_reader :caps, :filehash

    def initialize(file)

      @file = file
      @caps = []

      patterns = {}
      patterns["SUPPRESSION"] = "^suppress gen_id %{ID:GID}, sig_id %{ID:SID}(%{SUPPRESSIONOPTIONS})?(%{COMMENT})?"
      patterns["EVENTFILTER"] = "^event_filter gen_id %{ID:GID}, sig_id %{ID:SID}, type %{ETYPE}, track %{TRACK}, count %{COUNT}, seconds %{SECONDS}(%{COMMENT})?"
      patterns["RATEFILTER"] = "^rate_filter gen_id %{ID:GID}, sig_id %{ID:SID}, track %{TRACK}, count %{COUNT}, seconds %{SECONDS}, new_action %{NEW_ACTION}, timeout %{COUNT:TIMEOUT}(%{RATEFILTEROPTIONS})?(%{COMMENT})?"

      patterns["SUPPRESSIONOPTIONS"] = ", track %{TRACK}, ip %{IP}"
      patterns["RATEFILTEROPTIONS"] = ", apply_to %{IPCIDR}"
      
      patterns["ID"] = '\\d+'
      patterns["ETYPE"] = "limit|threshold|both"
      patterns["COUNT"] = "\\d+"
      patterns["SECONDS"] = "\\d+"
      patterns["TRACK"] = "by_src|by_dst|by_rule"
      patterns["COMMENT"] = "\s*?#.*"
      patterns["NEW_ACTION"] = 'alert|drop|pass|log|sdrop|reject'
      patterns["IPCIDR"] = '(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]).){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/([1-9]|[1-2][0-9]|3[0-2]))?'

      @grok = Grok.new
      patterns.each {|k,v| @grok.add_pattern(k,v)}
      @grok.add_patterns_from_file("lib/threshold/patterns/base")

      # Remember to call result["GID"].compact because of the PIPE or below in grok compile
      @grok.compile("^%{SUPPRESSION}|%{EVENTFILTER}|%{RATEFILTER}")
      
      loadfile(@file)
    end

    private 

    def loadfile(file)
        # FLOCK this and hash it.. 
        handler = File.open(file)
        handler.flock(File::LOCK_EX)
        handler.each do |line|
          match = @grok.match(line)
          @caps << match.captures if match
        end
        hash = Digest::MD5.file file
        handler.close
        @filehash = hash
    end

  end
end

