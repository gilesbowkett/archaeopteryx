# a quick note about FAIL. FileMIDI is actually of the same unspecified superclass as LiveMIDI. both
# need new, clearer names, but the nonexistent abstract superclass is just a class which takes options
# for args and has a method called play() which takes a note argument.

class FileMIDI
  attr_accessor :clock, :filename
  def initialize(options)
    raise :hell unless options.is_a? Hash
    @clock = options[:clock]
    @filename = options[:filename]
  end
  def play(note)
  end
end
