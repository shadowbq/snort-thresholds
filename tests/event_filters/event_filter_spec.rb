require File.join(File.dirname(__FILE__), "../spec_helper.rb")

describe Threshold::EventFilter do

#Standard working test of all fields
it 'prints a valid configuration line' do
    eventfilter = Threshold::EventFilter.new
    eventfilter.sid=123
    eventfilter.gid=456
    eventfilter.type='limit'
    eventfilter.track_by='src'
    eventfilter.count=10
    eventfilter.seconds=60
    expect(eventfilter.to_s).to eq 'event_filter gen_id 456, sig_id 123, type limit, track by_src, count 10, seconds 60'
end

#Standard working test of all fields
it 'prints a valid configuration line' do
    eventfilter = Threshold::EventFilter.new
    eventfilter.sid=123
    eventfilter.gid=456
    eventfilter.type='limit'
    eventfilter.track_by='src'
    eventfilter.count=10
    eventfilter.seconds=60
    eventfilter.comment="# This is a good line [smm]"
    expect(eventfilter.to_s).to eq 'event_filter gen_id 456, sig_id 123, type limit, track by_src, count 10, seconds 60 # This is a good line [smm]'
end

#Standard working test of all fields
it 'prints a valid configuration line' do
    eventfilter = Threshold::EventFilter.new
    eventfilter.sid=123
    eventfilter.gid=456
    eventfilter.type='limit'
    eventfilter.track_by='src'
    eventfilter.count=10
    eventfilter.seconds=60
    eventfilter.comment="# This is a good line [smm]"

    needle = Threshold::EventFilter.new
    needle.sid=123

    expect(eventfilter.include?(needle)).to eq true
end

#Standard working test of all fields
it 'prints a valid configuration line' do
    eventfilter = Threshold::EventFilter.new
    eventfilter.sid=123
    eventfilter.gid=456
    eventfilter.type='limit'
    eventfilter.track_by='src'
    eventfilter.count=10
    eventfilter.seconds=60
    eventfilter.comment="# This is a good line [smm]"

    needle = Threshold::EventFilter.new
    needle.gid=222

    expect(eventfilter.include?(needle)).to eq false
end

#Test failure missing sid
it 'should raise an Invalid EventFilter Object Error' do
    eventfilter = Threshold::EventFilter.new
    eventfilter.gid=456
    eventfilter.type='limit'
    eventfilter.track_by='src'
    eventfilter.count=10
    eventfilter.seconds=60
    expect {eventfilter.to_s}.to raise_error(Threshold::InvalidEventFilterObject)
  end

#Test failure missing gid
it 'should raise an Invalid EventFilter Object Error' do
    eventfilter = Threshold::EventFilter.new
    eventfilter.sid=123
    eventfilter.type='limit'
    eventfilter.track_by='src'
    eventfilter.count=10
    eventfilter.seconds=60
    expect {eventfilter.to_s}.to raise_error(Threshold::InvalidEventFilterObject)
  end

#Test failure missing type
it 'should raise an Invalid EventFilter Object Error' do
    eventfilter = Threshold::EventFilter.new
    eventfilter.sid=123
    eventfilter.gid=456
    eventfilter.track_by='src'
    eventfilter.count=10
    eventfilter.seconds=60
    expect {eventfilter.to_s}.to raise_error(Threshold::InvalidEventFilterObject)
  end

#Test failure missing track_by
it 'should raise an Invalid EventFilter Object Error' do
    eventfilter = Threshold::EventFilter.new
    eventfilter.sid=123
    eventfilter.gid=456
    eventfilter.type='limit'
    eventfilter.count=10
    eventfilter.seconds=60
    expect {eventfilter.to_s}.to raise_error(Threshold::InvalidEventFilterObject)
  end

#Test failure missing count
it 'should raise an Invalid EventFilter Object Error' do
    eventfilter = Threshold::EventFilter.new
    eventfilter.sid=123
    eventfilter.gid=456
    eventfilter.type='limit'
    eventfilter.track_by='src'
    eventfilter.seconds=60
    expect {eventfilter.to_s}.to raise_error(Threshold::InvalidEventFilterObject)
  end

#Test failure missing seconds
it 'should raise an Invalid EventFilter Object Error' do
    eventfilter = Threshold::EventFilter.new
    eventfilter.sid=123
    eventfilter.gid=456
    eventfilter.type='limit'
    eventfilter.track_by='src'
    eventfilter.count=10
    expect {eventfilter.to_s}.to raise_error(Threshold::InvalidEventFilterObject)
  end

#Test failure invalid sid
it 'should raise an Invalid EventFilter Object Error' do
    eventfilter = Threshold::EventFilter.new
    eventfilter.sid='123a'
    eventfilter.gid=456
    eventfilter.type='limit'
    eventfilter.track_by='src'
    eventfilter.count=10
    eventfilter.seconds=60
    expect {eventfilter.to_s}.to raise_error(Threshold::InvalidEventFilterObject)
  end

#Test failure invalid gid
it 'should raise an Invalid EventFilter Object Error' do
    eventfilter = Threshold::EventFilter.new
    eventfilter.sid=123
    eventfilter.gid='456a'
    eventfilter.type='limit'
    eventfilter.track_by='src'
    eventfilter.count=10
    eventfilter.seconds=60
    expect {eventfilter.to_s}.to raise_error(Threshold::InvalidEventFilterObject)
  end

#Test failure invalid type
it 'should raise an Invalid EventFilter Object Error' do
    eventfilter = Threshold::EventFilter.new
    eventfilter.sid=123
    eventfilter.gid=456
    eventfilter.type='count'
    eventfilter.track_by='src'
    eventfilter.count=10
    eventfilter.seconds=60
    expect {eventfilter.to_s}.to raise_error(Threshold::InvalidEventFilterObject)
  end

#Test failure invalid track_by
it 'should raise an Invalid EventFilter Object Error' do
    eventfilter = Threshold::EventFilter.new
    eventfilter.sid=123
    eventfilter.gid=456
    eventfilter.type='limit'
    eventfilter.track_by='both'
    eventfilter.count=10
    eventfilter.seconds=60
    expect {eventfilter.to_s}.to raise_error(Threshold::InvalidEventFilterObject)
  end

#Test failure invalid count
it 'should raise an Invalid EventFilter Object Error' do
    eventfilter = Threshold::EventFilter.new
    eventfilter.sid=123
    eventfilter.gid=456
    eventfilter.type='limit'
    eventfilter.track_by='src'
    eventfilter.count='once'
    eventfilter.seconds=60
    expect {eventfilter.to_s}.to raise_error(Threshold::InvalidEventFilterObject)
  end

#Test failure invalid seconds
it 'should raise an Invalid EventFilter Object Error' do
    eventfilter = Threshold::EventFilter.new
    eventfilter.sid=123
    eventfilter.gid=456
    eventfilter.type='limit'
    eventfilter.track_by='src'
    eventfilter.count=10
    eventfilter.seconds='1m'
    expect {eventfilter.to_s}.to raise_error(Threshold::InvalidEventFilterObject)
  end


end
