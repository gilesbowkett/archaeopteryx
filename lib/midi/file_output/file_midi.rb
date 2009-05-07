# a quick note about FAIL. FileMIDI is actually of the same unspecified superclass as LiveMIDI. both
# need new, clearer names, but the nonexistent abstract superclass is just a class which takes options
# for args and has a method called play() which takes a note argument.

include MIDI

# christ this should probably live in some kind of module or something

class FileMIDI
  attr_accessor :filename
  def initialize(options)
    raise :hell unless options.is_a? Hash
    @filename = options[:filename]
    @clock = options[:clock]
    @events = []
    
    @sequence = MIDI::Sequence.new
    @sequence.tracks << (@track = MIDI::Track.new(@sequence))
    @track.events << Tempo.new(Tempo.bpm_to_mpq(options[:tempo])) if options[:tempo]
    @track.events << MetaEvent.new(META_SEQ_NAME, options[:name]) if options[:name]
    
    # I'm not sure if this is actually necessary (?)
    @track.events << Controller.new(0, CC_VOLUME, 127)
    @track.events << ProgramChange.new(0, 1, 0)
  end
  def infinite?
    false
  end
  def midilib_delta
    # figuring this shit out was an epic fucking nightmare and to be honest I still have no idea why it works
    ((@sequence.note_to_delta("16th") / @clock.interval) * @clock.time).to_i
  end
  def play(note)
    @track.merge [NoteOnEvent.new(note.channel,
                                  note.number,
                                  note.velocity,
                                  midilib_delta)]
  end
  def write
    File.open(@filename, 'wb') do |file|
      @sequence.write(file)
    end
  end
end
