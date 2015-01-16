require File.join(File.dirname(__FILE__), "../spec_helper.rb")

describe Threshold::RateFilter do

#Standard working test of all fields
  it 'prints a valid configuration line' do
    ratefilter = Threshold::RateFilter.new
    ratefilter.sid=123
    ratefilter.gid=456
    ratefilter.track_by='src'
    ratefilter.count=10
    ratefilter.new_action = 'drop'
    ratefilter.seconds=60
    ratefilter.timeout=60
    expect(ratefilter.to_s).to eq 'rate_filter gen_id 456, sig_id 123, track by_src, count 10, new_action drop, seconds 60, timeout 60'
  end



end