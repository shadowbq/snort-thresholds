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
    expect(ratefilter.to_s).to eq 'rate_filter gen_id 456, sig_id 123, track by_src, count 10, seconds 60, new_action drop, timeout 60'
  end

  it 'prints a valid configuration line' do
    ratefilter = Threshold::RateFilter.new
    ratefilter.sid=123
    ratefilter.gid=456
    ratefilter.track_by='src'
    ratefilter.count=10
    ratefilter.new_action = 'drop'
    ratefilter.seconds=60
    ratefilter.timeout=60
    ratefilter.comment='# Finding the pit of success [smm]'
    expect(ratefilter.to_s).to eq 'rate_filter gen_id 456, sig_id 123, track by_src, count 10, seconds 60, new_action drop, timeout 60 # Finding the pit of success [smm]'
  end

  it 'prints a valid configuration line' do
    ratefilter = Threshold::RateFilter.new
    ratefilter.sid=123
    ratefilter.gid=456
    ratefilter.track_by='src'
    ratefilter.count=10
    ratefilter.new_action = 'drop'
    ratefilter.seconds=60
    ratefilter.timeout=60
    ratefilter.comment='# Finding the pit of success [smm]'
    expect(ratefilter.to_s).to eq 'rate_filter gen_id 456, sig_id 123, track by_src, count 10, seconds 60, new_action drop, timeout 60 # Finding the pit of success [smm]'
  end

  it 'should raise an Invalid RateFilter Object Error' do
    ratefilter = Threshold::RateFilter.new
    ratefilter.sid=123    
    ratefilter.track_by='src'
    ratefilter.count=10
    ratefilter.new_action='drop'
    ratefilter.seconds=60
    ratefilter.timeout=60
    ratefilter.comment='# Finding the pit of success [smm]'
    expect{ratefilter.to_s}.to raise_error(Threshold::InvalidRateFilterObject)
  end

  it 'should raise an Invalid RateFilter Object Error' do
    ratefilter = Threshold::RateFilter.new
    ratefilter.sid=123
    ratefilter.gid=456
    ratefilter.track_by='src'
    ratefilter.count=10
    ratefilter.new_action='alert'
    ratefilter.apply_to='1.2.4.5'
    ratefilter.seconds=60
    ratefilter.timeout=60
    ratefilter.comment='# Finding the pit of success [smm]'
    expect(ratefilter.to_s).to eq 'rate_filter gen_id 456, sig_id 123, count 10, seconds 60, new_action alert, timeout 60 apply_to 1.2.4.5 # Finding the pit of success [smm]'
  end


end