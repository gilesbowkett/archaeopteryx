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
    end
  end
end

# probably rename this to make it drum-specific
