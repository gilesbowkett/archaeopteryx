require 'lib/archaeopteryx'

describe FileMIDI do
  describe "things that may really belong to a nonexistent abstract superclass and not this class at all" do
    it "requires a filename" do
      FileMIDI.new(:filename => "foo.mid").should be_an_instance_of FileMIDI
      L{FileMIDI.new}.should raise_error
      L{FileMIDI.new("asdf")}.should raise_error
    end
    it "has a method called play" do
      L{FileMIDI.new(:filename => "foo.mid").play(Note.new)}.should_not raise_error
    end
  end
  describe "creating MIDI files" do
    before(:each) do
      @midi = FileMIDI.new(:filename => "foo.mid")
      @create_note = L{Note.create(:channel => 2,
                                   :number => 64,
                                   :duration => 0.25, # notes need better ways to express duration
                                   :velocity => 127)}
    end
    it "adds notes to itself" do
      2.times {@midi.play(@create_note[])}
      @midi.events.size.should == 2
    end
    it "has a MIDI sequence and track" do
      @midi.instance_variable_get("@track").should be_an_instance_of MIDI::Track
    end
  end
end
