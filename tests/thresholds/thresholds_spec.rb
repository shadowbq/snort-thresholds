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

  it 'correctly applies uniq to the class' do
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

  it 'correctly applies uniq blocks to the class' do
    thresholds = Threshold::Thresholds.new
    a1 = Threshold::Suppression.new
    a1.sid=123
    a1.gid=456
    b1 = Threshold::Suppression.new
    b1.sid=333
    b1.gid=456
    b1.comment = "# Comments Found here"

    thresholds.push(a1)
    thresholds.push(a1.clone)
    thresholds.push(a1.clone)
    thresholds.push(b1)

    expect(thresholds.uniq{|a| a.sid}.to_s).to eq "suppress gen_id 456, sig_id 123\nsuppress gen_id 456, sig_id 333 # Comments Found here\n"
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

  it 'prints a reverse sorted valid configuration file' do
    thresholds = Threshold::Thresholds.new
    thresholds.file='tests/samples/suppression.cfg'
    thresholds.loadfile
    expect(thresholds.sort.reverse.to_s).to eq "suppress gen_id 138, sig_id 5, track by_dst, ip 172.16.1.3\nsuppress gen_id 138, sig_id 5, track by_src, ip 172.16.1.3\nsuppress gen_id 129, sig_id 15, track by_src, ip 172.16.1.2\nsuppress gen_id 1, sig_id 24348\nsuppress gen_id 1, sig_id 21556  #Found more stuff dont need\nsuppress gen_id 1, sig_id 16008, track by_src, ip 172.16.1.2\nsuppress gen_id 1, sig_id 9999\nsuppress gen_id 1, sig_id 7861\nsuppress gen_id 1, sig_id 7567\nsuppress gen_id 1, sig_id 7537\nsuppress gen_id 1, sig_id 1852\nsuppress gen_id 1, sig_id 1156   # We don't want this\nsuppress gen_id 1, sig_id 3\nsuppress gen_id 1, sig_id 2\nrate_filter gen_id 1, sig_id 222, track by_dst, count 2, seconds 10, new_action drop, timeout 10  # More Comments\nrate_filter gen_id 1, sig_id 123, track by_dst, count 23, seconds 10, new_action alert, timeout 10\nrate_filter gen_id 1, sig_id 122, track by_rule, count 23, seconds 10, new_action alert, timeout 10\nevent_filter gen_id 31, sig_id 23, type limit, track by_src, count 3, seconds 101\nevent_filter gen_id 1, sig_id 123, type limit, track by_dst, count 23, seconds 10\n"
  end

  it 'prints a sorted valid configuration file while skipping comment output' do
    thresholds = Threshold::Thresholds.new
    thresholds.file='tests/samples/suppression.cfg'
    thresholds.loadfile
    expect(thresholds.sort.to_s(true)).to eq "event_filter gen_id 1, sig_id 123, type limit, track by_dst, count 23, seconds 10\nevent_filter gen_id 31, sig_id 23, type limit, track by_src, count 3, seconds 101\nrate_filter gen_id 1, sig_id 122, track by_rule, count 23, seconds 10, new_action alert, timeout 10\nrate_filter gen_id 1, sig_id 123, track by_dst, count 23, seconds 10, new_action alert, timeout 10\nrate_filter gen_id 1, sig_id 222, track by_dst, count 2, seconds 10, new_action drop, timeout 10\nsuppress gen_id 1, sig_id 2\nsuppress gen_id 1, sig_id 3\nsuppress gen_id 1, sig_id 1156\nsuppress gen_id 1, sig_id 1852\nsuppress gen_id 1, sig_id 7537\nsuppress gen_id 1, sig_id 7567\nsuppress gen_id 1, sig_id 7861\nsuppress gen_id 1, sig_id 9999\nsuppress gen_id 1, sig_id 16008, track by_src, ip 172.16.1.2\nsuppress gen_id 1, sig_id 21556\nsuppress gen_id 1, sig_id 24348\nsuppress gen_id 129, sig_id 15, track by_src, ip 172.16.1.2\nsuppress gen_id 138, sig_id 5, track by_src, ip 172.16.1.3\nsuppress gen_id 138, sig_id 5, track by_dst, ip 172.16.1.3\n"
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

  describe "when flushing a file" do

    before(:each) do
      @tmpfile = '/tmp/threshold.'+($$*rand(13)).to_s+'.test'
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

    it 'atomically prints a valid configuration file' do
      FileUtils.touch(@tmpfile)
      thresholds = Threshold::Thresholds.new
      thresholds.file=@tmpfile
      thresholds.loadfile
      a1 = Threshold::Suppression.new
      a1.sid=123
      a1.gid=456
      a2 = a1.clone
      a2.gid=444

      thresholds.push(a1)
      thresholds.push(a2)

      expect(thresholds.flush).to eq true
    end

    it 'invalidates on atomic lock failure, due to file never being loaded but existing' do
      FileUtils.touch(@tmpfile)
      thresholds = Threshold::Thresholds.new
      
      thresholds.file=@tmpfile
      a1 = Threshold::Suppression.new
      a1.sid=123
      a1.gid=456
      a2 = a1.clone
      a2.gid=444

      thresholds.push(a1)
      thresholds.push(a2)

      expect{ thresholds.flush }.to raise_error(Threshold::ThresholdAtomicLockFailure)
    end

    it 'invalidates on atomic lock failure, due to file being changed outside of scope' do
      require 'tempfile'
      file = Tempfile.new('thresholds')

      thresholds = Threshold::Thresholds.new
      thresholds.file=file.path
      thresholds.loadfile
      
      a1 = Threshold::Suppression.new
      a1.sid=123
      a1.gid=456
      a2 = a1.clone
      a2.gid=444

      thresholds.push(a1)
      thresholds.push(a2)
      thresholds.flush

      file.write("Hello World")

      expect{ thresholds.flush }.to raise_error(Threshold::ThresholdAtomicLockFailure)
    end

    after(:each) do
      FileUtils.rm_r @tmpfile, :force => true 
    end

  end

  describe "index checking" do
    before(:all) do
      @thresholds = Threshold::Thresholds.new
      @thresholds.file='tests/samples/suppression.cfg'
      b = Threshold::Suppression.new
      b.gid=124
      b.sid=45544
      @thresholds << b
      @thresholds << b.clone
    end

    it 'should be able to compare numerical indexes' do
      d = Threshold::Suppression.new
      d.gid=124
      d.sid=45544
      expect(@thresholds[0] == d).to eq true
    end

    it 'should be able to compare indexes' do
      d = Threshold::Suppression.new
      d.gid=124
      d.sid=45544
      expect(@thresholds.index(d)).to eq 0
    end

    it 'should be able to compare include? alias' do
      d = Threshold::Suppression.new
      d.gid=124
      d.sid=45544
      expect(@thresholds.include?(d)).to eq true
    end

  end

  describe "complex set equality" do
    before(:all) do
      @t1 = Threshold::Thresholds.new
      @t1.file='tests/samples/suppression.cfg'

      @t1.loadfile

      @t2 = Threshold::Thresholds.new
      @t2.file='tests/samples/suppression.cfg'
      @t2.loadfile

      s = Threshold::Suppression.new
      s.gid=99
      s.sid=12345
      @t2 << s
    end
    
    ## &(union), | (intersect), + (concat), - (Difference) 
    it 'should be able to union two thresholds' do
      expect((@t2 & @t1).length).to eq 19
    end

    it 'should be able to intersect two thresholds' do
      expect((@t2 | @t1).length).to eq 20
    end

    it 'should be able to concat two thresholds' do
      expect((@t2 + @t1).length).to eq 39
    end

    it 'should be able to Difference two thresholds' do
      expect((@t2 - @t1).length).to eq 1
    end

  end

end