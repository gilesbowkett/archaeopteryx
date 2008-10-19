module Archaeopteryx
  class Mix
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
    def messages(beat) # obviously these should be refactored to inject()s
      messages = []
      @rhythms.each do |rhythm|
        messages << rhythm.messages(beat)
      end
      messages.flatten
    end
    def mutate(measure)
      @rhythms.each {|rhythm| rhythm.mutate(measure)}
    end
  end
end

# Mix nearly identical to Rhythm
