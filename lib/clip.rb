module Archaeopteryx
  class Clip
    def initialize(attributes)
      @message = Message.create(attributes.merge(:midi_channel => 0, :value => 127))
    end
    def notes(beat)
      []
    end
    def messages(beat)
      [@message]
    end
    def mutate(measure)
    end
  end
end

# probably rename this to make it drum-specific
