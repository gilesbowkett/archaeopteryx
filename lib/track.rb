module Archaeopteryx
  class Track < Mix
    def messages(beat)
      @rhythms.random.messages(beat)
    end
  end
end
