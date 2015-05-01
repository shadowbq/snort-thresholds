module Threshold
  #Returns an Array of Grok Captures from the input file matching Threshold Conf standards
  class Builder
    def initialize(parsed_data)
      @parsed_data = parsed_data
      @parsed_data.reject! {|k,v| v.compact.first == nil }
    end

    def build
      #Strip out NIL Stuctures
      if @parsed_data.key?("SUPPRESSION")
        return Threshold::Suppression.new(@parsed_data)
      elsif @parsed_data.key?("RATEFILTER")
        return Threshold::RateFilter.new(@parsed_data)
      else @parsed_data.key?("EVENTFILTER")
        return Threshold::EventFilter.new(@parsed_data)
      end
    end
  end
end
