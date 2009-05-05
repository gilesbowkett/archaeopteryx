require 'lib/archaeopteryx'

describe FileMIDI do
  it "requires options: a clock and a filename" do
    FileMIDI.new(:clock => Clock.new(170),
                 :filename => "foo.mid").should be_an_instance_of FileMIDI
    L{FileMIDI.new}.should raise_error
    L{FileMIDI.new("asdf")}.should raise_error
  end
end
