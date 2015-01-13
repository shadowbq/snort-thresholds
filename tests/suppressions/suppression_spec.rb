require File.join(File.dirname(__FILE__), "../spec_helper.rb")

describe Threshold::Suppression do

#Standard SID and GID test with no additional data
  it 'prints a valid configuration line' do
    suppression = Threshold::Suppression.new
    suppression.sid=123
    suppression.gid=456
    expect(suppression.to_s).to eq 'suppress gen_id 456, sig_id 123'
  end

#Standard SID GID Track by_src and IP test
  it 'prints a valid configuration line' do
    suppression = Threshold::Suppression.new
    suppression.sid=123
    suppression.gid=456
    suppression.track_by='src'
    suppression.ip='1.2.3.4'
    expect(suppression.to_s).to eq 'suppress gen_id 456, sig_id 123, track by_src, ip 1.2.3.4'
  end

#Standard SID GID Track by_dst and IP test
 it 'prints a valid configuration line' do
    suppression = Threshold::Suppression.new
    suppression.sid=123
    suppression.gid=456
    suppression.track_by='dst'
    suppression.ip='1.2.3.4'
    expect(suppression.to_s).to eq 'suppress gen_id 456, sig_id 123, track by_dst, ip 1.2.3.4'
  end

 #Standard SID GID Track by_dst and full IP length test
 it 'prints a valid configuration line' do
    suppression = Threshold::Suppression.new
    suppression.sid=123
    suppression.gid=456
    suppression.track_by='dst'
    suppression.ip='100.200.103.114'
    expect(suppression.to_s).to eq 'suppress gen_id 456, sig_id 123, track by_dst, ip 100.200.103.114'
  end

#Standard SID GID Track by_src and double digit CIRD IP test
  it 'prints a valid configuration line' do
    suppression = Threshold::Suppression.new
    suppression.sid=123
    suppression.gid=456
    suppression.track_by='src'
    suppression.ip='1.2.3.4/20'
    expect(suppression.to_s).to eq 'suppress gen_id 456, sig_id 123, track by_src, ip 1.2.3.4/20'
  end

#Standard SID GID Track by_src and single digit CIRD IP test
  it 'prints a valid configuration line' do
    suppression = Threshold::Suppression.new
    suppression.sid=123
    suppression.gid=456
    suppression.track_by='src'
    suppression.ip='1.2.3.4/8'
    expect(suppression.to_s).to eq 'suppress gen_id 456, sig_id 123, track by_src, ip 1.2.3.4/8'
  end

#Test failure if CIDR is too long
it 'prints a valid configuration line' do
    suppression = Threshold::Suppression.new
    suppression.sid=123
    suppression.gid=456
    suppression.track_by='src'
    suppression.ip='1.2.3.4/208'
    expect { suppression.to_s }.to raise_error(Threshold::InvalidSuppressionObject)
  end


#Test failure of no IP set but Track by_ set
  it 'should raise an Invalid Suppression Object Error' do
    suppression = Threshold::Suppression.new
    suppression.sid=123
    suppression.gid=456
    suppression.track_by='src'
    suppression.ip=''
    expect { suppression.to_s }.to raise_error(Threshold::InvalidSuppressionObject)
  end

#Test failure on SID and Track by_ set with no GID or IP set
  it 'should raise an Invalid Suppression Object Error' do
    suppression = Threshold::Suppression.new
    suppression.sid=123
    suppression.track_by='src'
    expect { suppression.to_s }.to raise_error(Threshold::InvalidSuppressionObject)
  end

#Test failure on SID set but no GID
    it 'should raise an Invalid Suppression Object Error' do
    suppression = Threshold::Suppression.new
    suppression.sid=123
    expect { suppression.to_s }.to raise_error(Threshold::InvalidSuppressionObject)
  end

#Test failure on GID set with no SID
    it 'should raise an Invalid Suppression Object Error' do
    suppression = Threshold::Suppression.new
    suppression.gid=234
    expect { suppression.to_s }.to raise_error(Threshold::InvalidSuppressionObject)
  end

#Test failure on too many octects in IP
  it 'should raise an Invalid Suppression Object Error' do
    suppression = Threshold::Suppression.new
    suppression.sid=123
    suppression.gid=456
    suppression.track_by='src'
    suppression.ip='1.2.3.4.5'
    expect { suppression.to_s }.to raise_error(Threshold::InvalidSuppressionObject)
  end

#Test failure on invalid IP address
  it 'should raise an Invalid Suppression Object Error' do
    suppression = Threshold::Suppression.new
    suppression.sid=123
    suppression.gid=456
    suppression.track_by='src'
    suppression.ip='100.200.300.400'
    expect { suppression.to_s }.to raise_error(Threshold::InvalidSuppressionObject)
  end

#Test failure on invalid CIDR range of 0
  it 'should raise an Invalid Suppression Object Error' do
    suppression = Threshold::Suppression.new
    suppression.sid=123
    suppression.gid=456
    suppression.track_by='src'
    suppression.ip='1.2.3.4/0'
    expect { suppression.to_s }.to raise_error(Threshold::InvalidSuppressionObject)
  end

end


=begin
[3] pry(main)> a = Suppression.new
=> #<Suppression:0x000000017c7530>
[4] pry(main)> a.sid=123
=> 123
[5] pry(main)> a.gid=456
=> 456
[6] pry(main)> puts a
suppress gen_id 456, sig_id 123
=> nil
[7] pry(main)> a.tack_by
NoMethodError: undefined method `tack_by' for #<Suppression:0x000000017c7530 @sid=123, @gid=456>
from (pry):7:in `__pry__'
[8] pry(main)> a.track_by
=> nil
[9] pry(main)> a.track_by='src'
=> "src"
[10] pry(main)> a.ip='1.2.3.4'
=> "1.2.3.4"
[11] pry(main)> puts a
suppress gen_id 456, sig_id 123, track by_src, ip 1.2.3.4
=> nil
[12] pry(main)> a.ip = nil
=> nil
[13] pry(main)> puts a
InvalidSuppressionObject: Object did not validate
from suppression.rb:48:in `to_s'
[14] pry(main)> a
=> #<Suppression:0x000000017c7530 @gid=456, @ip=nil, @sid=123, @track_by="src">
[15] pry(main)> a.ip='1.2.3.4'
=> "1.2.3.4"
[16] pry(main)> puts a
suppress gen_id 456, sig_id 123, track by_src, ip 1.2.3.4
=> nil
[17] pry(main)> a.track_by='fff'
=> "fff"
[18] pry(main)> puts a
InvalidSuppressionObject: Object did not validate
from suppression.rb:48:in `to_s'
[19] pry(main)> a.track_by = nil
=> nil
[20] pry(main)> puts a
InvalidSuppressionObject: Object did not validate
from suppression.rb:48:in `to_s'
[21] pry(main)> a
=> #<Suppression:0x000000017c7530
 @gid=456,
 @ip="1.2.3.4",
 @sid=123,
 @track_by=nil>
[22] pry(main)> a.ip= nil
=> nil
[23] pry(main)> puts a
suppress gen_id 456, sig_id 123
=> nil
[24] pry(main)> a.ip= '1.2.3.5/23'
=> "1.2.3.5/23"
[25] pry(main)> a.track_by='dst'
=> "dst"
[26] pry(main)> puts a
suppress gen_id 456, sig_id 123, track by_dst, ip 1.2.3.5/23
=> nil
[27] pry(main)> exit

  
=end
