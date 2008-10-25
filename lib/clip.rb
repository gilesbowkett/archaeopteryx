module Archaeopteryx
  class Clip
    attr_accessor :measures
    def initialize(attributes)
      @message = Message.create(attributes.merge(:midi_channel => 0,
                                                 :value => 127))
      @measures = attributes[:measures]
    end
    def notes(measure)
      []
    end
    def messages(measure)
      0 == measure % @measures ? [@message] : []
    end
    def mutate(measure)
    end
    def complete?
      [true, false][rand(2)]
      # current_measure == final_measure
      # BUT! these need to be relative measures in this Clip, not absolute measures in the overall Loop
      # possible that Loop should be called Engine or some crazy shit
    end
  end
end

# probably rename this to make it drum-specific
