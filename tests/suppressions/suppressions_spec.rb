require File.join(File.dirname(__FILE__), "../spec_helper.rb")

describe Threshold::Suppressions do

## Pre-build the Suppressions object.. can we do a with object?

#Standard SID and GID test with no additional data
  it 'validates' do
    suppressions = Threshold::Suppressions.new
    a1 = Threshold::Suppression.new
    a1.sid=123
    a1.gid=456
    a2 = a1.clone
    a2.gid=444

    suppressions.push(a1)
    suppressions.push(a2)

    expect(suppressions.valid?).to eq true
  end

  it 'prints a valid configuration line' do
    suppressions = Threshold::Suppressions.new
    a1 = Threshold::Suppression.new
    a1.sid=123
    a1.gid=456
    a2 = a1.clone
    a2.gid=444

    suppressions.push(a1)
    suppressions.push(a2)

    expect(suppressions.to_s).to eq "suppress gen_id 456, sig_id 123\nsuppress gen_id 444, sig_id 123\n"
  end

end