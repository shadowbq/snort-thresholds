require File.join(File.dirname(__FILE__), "../spec_helper.rb")

describe Threshold::Thresholds do

## Pre-build the Thresholds object.. can we do a with object?

  before(:all) do
    # this is here as an example, but is not really
    # necessary. Since each example is run in its
    # own object, instance variables go out of scope
    # between each example.
    @tmpfile = '/tmp/threshold.'+($$*rand(13)).to_s+'.test'
  end

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

  it 'correctly appllys uniq to the class' do
    thresholds = Threshold::Thresholds.new
    a1 = Threshold::Suppression.new
    a1.sid=123
    a1.gid=456
    b1 = Threshold::Suppression.new
    b1.sid=123
    b1.gid=456
    b1.comment = "# Comments Found here"

    thresholds.push(a1)
    thresholds.push(a1.clone)
    thresholds.push(a1.clone)
    thresholds.push(b1)

    expect(thresholds.uniq.to_s).to eq "suppress gen_id 456, sig_id 123\n"
  end

  it 'prints a valid configuration line' do
    thresholds = Threshold::Thresholds.new
    a1 = Threshold::Suppression.new
    a1.sid=123
    a1.gid=456
    a2 = a1.clone
    a2.gid=444

    thresholds.push(a1)
    thresholds.push(a1.clone)
    thresholds.push(a2)
    thresholds.push(a2.clone)

    expect(thresholds.uniq{|t| t.sid}.to_s).to eq "suppress gen_id 456, sig_id 123\n"
  end

  it 'prints a valid configuration line after appending comments' do
    thresholds = Threshold::Thresholds.new
    a1 = Threshold::Suppression.new
    a1.sid=123
    a1.gid=456
    a2 = a1.clone
    a2.gid=444
    thresholds.push(a1)
    thresholds.push(a2)

    thresholds.collect! {|d| d.comment = "# add comments everywhere"; d}
    
    expect(thresholds.to_s).to eq "suppress gen_id 456, sig_id 123 # add comments everywhere\nsuppress gen_id 444, sig_id 123 # add comments everywhere\n"
  end
  
  it 'prints a valid configuration file' do
    thresholds = Threshold::Thresholds.new
    thresholds.file='tests/samples/suppression.cfg'
    thresholds.loadfile
    expect(thresholds.to_s).to eq "suppress gen_id 1, sig_id 2\nsuppress gen_id 1, sig_id 3\nsuppress gen_id 129, sig_id 15, track by_src, ip 172.16.1.2\nsuppress gen_id 138, sig_id 5, track by_src, ip 172.16.1.3\nsuppress gen_id 138, sig_id 5, track by_dst, ip 172.16.1.3\nsuppress gen_id 1, sig_id 16008, track by_src, ip 172.16.1.2\nsuppress gen_id 1, sig_id 1852\nevent_filter gen_id 1, sig_id 123, type limit, track by_dst, count 23, seconds 10\nevent_filter gen_id 31, sig_id 23, type limit, track by_src, count 3, seconds 101\nsuppress gen_id 1, sig_id 21556  #Found more stuff dont need\nsuppress gen_id 1, sig_id 9999\nsuppress gen_id 1, sig_id 7567\nsuppress gen_id 1, sig_id 7861\nsuppress gen_id 1, sig_id 1156   # We don't want this\nsuppress gen_id 1, sig_id 24348\nrate_filter gen_id 1, sig_id 123, track by_dst, count 23, seconds 10, new_action alert, timeout 10\nrate_filter gen_id 1, sig_id 222, track by_dst, count 2, seconds 10, new_action drop, timeout 10  # More Comments\nrate_filter gen_id 1, sig_id 122, track by_rule, count 23, seconds 10, new_action alert, timeout 10\nsuppress gen_id 1, sig_id 7537\n"
  end

  it 'prints a sorted valid configuration file' do
    thresholds = Threshold::Thresholds.new
    thresholds.file='tests/samples/suppression.cfg'
    thresholds.loadfile
    expect(thresholds.sort.to_s).to eq "event_filter gen_id 1, sig_id 123, type limit, track by_dst, count 23, seconds 10\nevent_filter gen_id 31, sig_id 23, type limit, track by_src, count 3, seconds 101\nrate_filter gen_id 1, sig_id 122, track by_rule, count 23, seconds 10, new_action alert, timeout 10\nrate_filter gen_id 1, sig_id 123, track by_dst, count 23, seconds 10, new_action alert, timeout 10\nrate_filter gen_id 1, sig_id 222, track by_dst, count 2, seconds 10, new_action drop, timeout 10  # More Comments\nsuppress gen_id 1, sig_id 2\nsuppress gen_id 1, sig_id 3\nsuppress gen_id 1, sig_id 1156   # We don't want this\nsuppress gen_id 1, sig_id 1852\nsuppress gen_id 1, sig_id 7537\nsuppress gen_id 1, sig_id 7567\nsuppress gen_id 1, sig_id 7861\nsuppress gen_id 1, sig_id 9999\nsuppress gen_id 1, sig_id 16008, track by_src, ip 172.16.1.2\nsuppress gen_id 1, sig_id 21556  #Found more stuff dont need\nsuppress gen_id 1, sig_id 24348\nsuppress gen_id 129, sig_id 15, track by_src, ip 172.16.1.2\nsuppress gen_id 138, sig_id 5, track by_src, ip 172.16.1.3\nsuppress gen_id 138, sig_id 5, track by_dst, ip 172.16.1.3\n"
  end

  it 'prints a sorted valid configuration file while skipping comment output' do
    thresholds = Threshold::Thresholds.new
    thresholds.file='tests/samples/suppression.cfg'
    thresholds.loadfile
    expect(thresholds.sort.to_s(true)).to eq "event_filter gen_id 1, sig_id 123, type limit, track by_dst, count 23, seconds 10\nevent_filter gen_id 31, sig_id 23, type limit, track by_src, count 3, seconds 101\nrate_filter gen_id 1, sig_id 122, track by_rule, count 23, seconds 10, new_action alert, timeout 10\nrate_filter gen_id 1, sig_id 123, track by_dst, count 23, seconds 10, new_action alert, timeout 10\nrate_filter gen_id 1, sig_id 222, track by_dst, count 2, seconds 10, new_action drop, timeout 10\nsuppress gen_id 1, sig_id 2\nsuppress gen_id 1, sig_id 3\nsuppress gen_id 1, sig_id 1156\nsuppress gen_id 1, sig_id 1852\nsuppress gen_id 1, sig_id 7537\nsuppress gen_id 1, sig_id 7567\nsuppress gen_id 1, sig_id 7861\nsuppress gen_id 1, sig_id 9999\nsuppress gen_id 1, sig_id 16008, track by_src, ip 172.16.1.2\nsuppress gen_id 1, sig_id 21556\nsuppress gen_id 1, sig_id 24348\nsuppress gen_id 129, sig_id 15, track by_src, ip 172.16.1.2\nsuppress gen_id 138, sig_id 5, track by_src, ip 172.16.1.3\nsuppress gen_id 138, sig_id 5, track by_dst, ip 172.16.1.3\n"
  end

  it 'prints a valid configuration file' do
    thresholds = Threshold::Thresholds.new
    a1 = Threshold::Suppression.new
    a1.sid=123
    a1.gid=456
    a2 = a1.clone
    a2.gid=444

    thresholds.push(a1)
    thresholds.push(a2)

    thresholds.file=@tmpfile
    expect(thresholds.flush).to eq true
  end

  it 'raises an error due to lack of threshold.conf being defined' do
    thresholds = Threshold::Thresholds.new
    expect{ thresholds.loadfile }.to raise_error(Threshold::MissingThresholdFileConfiguration)
  end

  it 'invalidates on a bad object in the container' do
    thresholds = Threshold::Thresholds.new
    thresholds.file='tests/samples/suppression.cfg'
    thresholds.loadfile
    a1 = Threshold::Suppression.new
    a1.sid=123
    thresholds.push(a1)
    expect(thresholds.valid?).to eq false
  end

  it 'invalidates on a bad object in the container' do
    thresholds = Threshold::Thresholds.new
    thresholds.file='tests/samples/suppression.cfg'
    thresholds.loadfile
    a1 = Threshold::Suppression.new
    a1.sid=123
    thresholds.push(a1)
    expect{ thresholds.to_s }.to raise_error(Threshold::InvalidThresholdsObject)
  end

  it 'should be able to reject objects' do
    thresholds = Threshold::Thresholds.new
    thresholds.file='tests/samples/suppression.cfg'
    thresholds.loadfile
    thresholds = thresholds.reject{|t| t.gid == 1}
    expect(thresholds.length).to eq 4
  end

  it 'should be able to reject non-destructively' do
    thresholds = Threshold::Thresholds.new
    thresholds.file='tests/samples/suppression.cfg'
    thresholds.loadfile
    thresholds.reject{|t| t.gid == 1}
    expect(thresholds.length).to eq 19
  end

  it 'should be able to select objects' do
    thresholds = Threshold::Thresholds.new
    thresholds.file='tests/samples/suppression.cfg'
    thresholds.loadfile
    thresholds = thresholds.select{|t| t.gid == 1}
    expect(thresholds.length).to eq 15
  end

  it 'should be able to select objects non-destructively' do
    thresholds = Threshold::Thresholds.new
    thresholds.file='tests/samples/suppression.cfg'
    thresholds.loadfile
    thresholds.select{|t| t.gid == 1}
    expect(thresholds.length).to eq 19
  end

  after(:all) do
    # this is here as an example, but is not really
    # necessary. Since each example is run in its
    # own object, instance variables go out of scope
    # between each example.
    FileUtils.rm_r @tmpfile, :force => true 
  end

end