module Archaeopteryx
  class Track < Mix
    def messages(measure)
      @current = @rhythms.random
      @current.messages(measure)
    end
  end
end
