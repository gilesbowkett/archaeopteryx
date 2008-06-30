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
    # Haskell style! Lisp style?! Recursion style!
    # def notes(beat)
    #   notes = []
    #   @rhythms.each do |rhythm|
    #     notes << rhythm.notes(beat)
    #   end
    # end
    def mutate(measure)
      @rhythms.each {|rhythm| rhythm.mutate(measure)}
    end
  end
end

# Mix nearly identical to Rhythm
