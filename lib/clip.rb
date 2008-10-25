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
      # if 0 == @relative_measure % @measures
      #   [@message]
      # else
      #   []
      #   @relative_measure += 1
      # end
    end
    def mutate(measure)
    end
    # def choose
    #   relative_measure = 1
    #   etc.
    # end
    def complete?
      [true, false][rand(2)]
      # current_measure == final_measure
      # BUT! these need to be relative measures in this Clip, not absolute measures in the overall Loop
      # possible that Loop should be called Engine or some crazy shit
      # I guess relative_measure is really @current_measure
    end
  end
end

# probably rename this to make it drum-specific
