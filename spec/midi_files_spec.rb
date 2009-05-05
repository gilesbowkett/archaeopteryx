require 'lib/archaeopteryx'

describe FileMIDI do
  it "requires a clock" do
    FileMIDI.new(Clock.new(170)).should be_an_instance_of FileMIDI
    L{FileMIDI.new}.should raise_error
  end
end
