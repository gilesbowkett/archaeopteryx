require 'lib/archaeopteryx'

describe FileMIDI do
  describe "things that may really belong to a nonexistent abstract superclass and not this class at all" do
    it "requires a filename" do
      FileMIDI.new(:filename => "foo.midi").should be_an_instance_of FileMIDI
      L{FileMIDI.new}.should raise_error
      L{FileMIDI.new("asdf")}.should raise_error
    end
    it "has a method called play" do
      L{FileMIDI.new(:filename => "foo.midi").play(Note.new)}.should_not raise_error
    end
  end
  describe "things that are kinda convoluted because of integrating the midilib gem" do
    before(:each) do
      @midi = FileMIDI.new(:filename => "foo.midi")
      @create_note = L{Note.create(:channel => 2,
                                   :number => 64,
                                   :duration => 0.25, # notes need better ways to express duration
                                   :velocity => 127)}
    end
    it "adds notes to itself" do
      2.times {@midi.play(@create_note[])}
      (@midi.instance_variable_get("@track").events.select do |note|
        note.class == MIDI::NoteOnEvent
      end).size.should == 2
    end
    it "has a MIDI sequence and track" do
      @midi.instance_variable_get("@sequence").should be_an_instance_of MIDI::Sequence
      @midi.instance_variable_get("@track").should be_an_instance_of MIDI::Track
    end
    it "creates tempo midi events" do
      Tempo.should_receive(:new)
      Tempo.should_receive(:bpm_to_mpq).with(175)
      @midi = FileMIDI.new(:filename => "foo.midi",
                           :tempo => 175)
    end
    it "sets sequence name" do
      MetaEvent.should_receive(:new).with(META_SEQ_NAME, "fuzzy ballistics")
      @midi = FileMIDI.new(:filename => "foo.midi",
                           :name => "fuzzy ballistics")
    end
  end
  describe "creating MIDI files" do
  end
end
