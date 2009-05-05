# a quick note about FAIL. FileMIDI is actually of the same unspecified superclass as LiveMIDI. both
# need new, clearer names, but the nonexistent abstract superclass is just a class which takes options
# for args and has a method called play() which takes a note argument.

require 'midilib/sequence'
require 'midilib/consts'
include MIDI

class FileMIDI
  attr_accessor :filename,
                :events
  def initialize(options)
    raise :hell unless options.is_a? Hash
    @filename = options[:filename]
    @events = []
    
    @sequence = MIDI::Sequence.new
    @sequence.tracks << (@track = MIDI::Track.new(@sequence))
    @track.events << Tempo.new(Tempo.bpm_to_mpq(options[:tempo])) if options[:tempo]
    @track.events << MetaEvent.new(META_SEQ_NAME, options[:name]) if options[:name]
  end
  def play(note)
    @events << note
  end
end

# I think what this has to do is have a ticker. because it expects to tick, and you're using predefined
# intervals. so if you've got a ticker, you just have to check if it's ticked, or something. actually I
# have no idea - I don't know how midilib tracks time.
