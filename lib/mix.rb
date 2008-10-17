module Archaeopteryx
  class Mix
    attr_accessor :rhythms
    def initialize(attributes)
      @rhythms = attributes[:rhythms]
    end
    def notes(beat)
      notes = []
      @rhythms.each do |rhythm|
        notes << rhythm.notes(beat)
      end
      notes.flatten
    end
    def mutate(measure)
      @rhythms.each {|rhythm| rhythm.mutate(measure)}
    end
  end
end

# Mix nearly identical to Rhythm
