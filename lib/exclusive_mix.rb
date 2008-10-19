module Archaeopteryx
  class ExclusiveMix < Mix
    def messages(beat)
      @rhythms.random.messages(beat)
    end
  end
end
