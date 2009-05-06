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
  def play(note)
    # http://github.com/jvoorhis/music.rb/blob/5cf79915dda155d4e8348750d731739c85ac1e60/lib/music/smf_writer.rb
    @track.events << NoteOnEvent.new(note.channel,
                                     note.number,
                                     note.velocity,
                                     0) # this number here should carry an offset representing the
                                     # amount of time since the last message in this stream. it's still
                                     # not clear to me how to handle simultaneous notes, however.
    # @track.events << NoteOffEvent.new(note.channel,
    #                                  note.number,
    #                                  note.velocity,
    #                                  @sequence.note_to_delta("16th")) # yeah, well, whatever
  end
  def write
    File.open(@filename, 'wb') do |file|
    	@sequence.write(file)
    end
  end
end

# I think what this has to do is have a ticker. because it expects to tick, and you're using predefined
# intervals. so if you've got a ticker, you just have to check if it's ticked, or something. actually I
# have no idea - I don't know how midilib tracks time.
