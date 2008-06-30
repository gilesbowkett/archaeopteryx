# this file is useless and consists entirely of me thinking out loud.


module Archaeopteryx
  class Scale
    attr_accessor :notes
    def initialize(attributes)
      @notes = attributes[:notes]
    end
    def /(positions)
      positions.inject([]) do |notes_matching_positions, position|
        notes_matching_positions << @notes[position]
      end
    end
  end
end

# the idea here is you've got an arpeggio, say the 1st, 3rd, and 5th. if you run that against a scale,
# you return the 1st, 3rd, and 5th of that scale. the problem here is that some as yet uncreated object
# has to feed the scale its current set of notes - or, alternatively, something has to continually cycle
# across 12 scales. that's probably the answer, actually - a Wheel or Circle model which is essentially
# an ouroboros queue.

# the Sequence model is almost there, but not quite.

# probably there should be an ouroboros queue model and both Sequence and Wheel/Circle should inherit
# from it? or is that the insaniest overkill evar?

# turns out this ouroboros queue may already exist as a pattern with the much simpler name ring.

