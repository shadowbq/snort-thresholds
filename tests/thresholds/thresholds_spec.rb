require File.join(File.dirname(__FILE__), "../spec_helper.rb")

describe Threshold::Thresholds do

## Pre-build the Thresholds object.. can we do a with object?

#Standard SID and GID test with no additional data
  it 'validates' do
    thresholds = Threshold::Thresholds.new
    a1 = Threshold::Suppression.new
    a1.sid=123
    a1.gid=456
    a2 = a1.clone
    a2.gid=444

    thresholds.push(a1)
    thresholds.push(a2)

    expect(thresholds.valid?).to eq true
  end

  it 'prints a valid configuration line' do
    thresholds = Threshold::Thresholds.new
    a1 = Threshold::Suppression.new
    a1.sid=123
    a1.gid=456
    a2 = a1.clone
    a2.gid=444

    thresholds.push(a1)
    thresholds.push(a2)

    expect(thresholds.to_s).to eq "suppress gen_id 456, sig_id 123\nsuppress gen_id 444, sig_id 123\n"
  end

  it 'prints a valid configuration file' do
    thresholds = Threshold::Thresholds.new
    thresholds.loadfile
    expect(thresholds.to_s).to eq "suppress gen_id 1, sig_id 2\nsuppress gen_id 1, sig_id 3\nsuppress gen_id 129, sig_id 15, track by_src, ip 172.16.1.2\nsuppress gen_id 138, sig_id 5, track by_src, ip 172.16.1.3\nsuppress gen_id 138, sig_id 5, track by_dst, ip 172.16.1.3\nsuppress gen_id 1, sig_id 16008, track by_src, ip 172.16.1.2\nsuppress gen_id 1, sig_id 1852\nevent_filter gen_id 1, sig_id 123, type limit, track by_dst, count 23, seconds 10\nevent_filter gen_id 31, sig_id 23, type limit, track by_src, count 3, seconds 101\nsuppress gen_id 1, sig_id 21556  #Found more stuff dont need\n\nsuppress gen_id 1, sig_id 9999\nsuppress gen_id 1, sig_id 7567\nsuppress gen_id 1, sig_id 7861\nsuppress gen_id 1, sig_id 1156   # We don't want this\n\nsuppress gen_id 1, sig_id 24348\nrate_filter gen_id 1, sig_id 123, track by_dst, count 23, seconds 10, new_action alert, timeout 10\nrate_filter gen_id 1, sig_id 222, track by_dst, count 2, seconds 10, new_action drop, timeout 10  # More Comments\n\nrate_filter gen_id 1, sig_id 122, track by_rule, count 23, seconds 10, new_action alert, timeout 10\nsuppress gen_id 1, sig_id 7537\n"
  end

  it 'prints a sorted valid configuration file' do
    thresholds = Threshold::Thresholds.new
    thresholds.loadfile
    expect(thresholds.sort.to_s).to eq "event_filter gen_id 1, sig_id 123, type limit, track by_dst, count 23, seconds 10\nevent_filter gen_id 31, sig_id 23, type limit, track by_src, count 3, seconds 101\nrate_filter gen_id 1, sig_id 122, track by_rule, count 23, seconds 10, new_action alert, timeout 10\nrate_filter gen_id 1, sig_id 123, track by_dst, count 23, seconds 10, new_action alert, timeout 10\nrate_filter gen_id 1, sig_id 222, track by_dst, count 2, seconds 10, new_action drop, timeout 10  # More Comments\n\nsuppress gen_id 1, sig_id 2\nsuppress gen_id 1, sig_id 3\nsuppress gen_id 1, sig_id 1156   # We don't want this\n\nsuppress gen_id 1, sig_id 1852\nsuppress gen_id 1, sig_id 7537\nsuppress gen_id 1, sig_id 7567\nsuppress gen_id 1, sig_id 7861\nsuppress gen_id 1, sig_id 9999\nsuppress gen_id 1, sig_id 16008, track by_src, ip 172.16.1.2\nsuppress gen_id 1, sig_id 21556  #Found more stuff dont need\n\nsuppress gen_id 1, sig_id 24348\nsuppress gen_id 129, sig_id 15, track by_src, ip 172.16.1.2\nsuppress gen_id 138, sig_id 5, track by_src, ip 172.16.1.3\nsuppress gen_id 138, sig_id 5, track by_dst, ip 172.16.1.3\n"
  end

  it 'invalidates on a bad object in the container' do
    thresholds = Threshold::Thresholds.new
    thresholds.loadfile
    a1 = Threshold::Suppression.new
    a1.sid=123
    thresholds.push(a1)
    expect(thresholds.valid?).to eq false
  end

  it 'invalidates on a bad object in the container' do
    thresholds = Threshold::Thresholds.new
    thresholds.loadfile
    a1 = Threshold::Suppression.new
    a1.sid=123
    thresholds.push(a1)
    expect{ thresholds.to_s }.to raise_error(Threshold::InvalidThresholdsObject)
  end

end