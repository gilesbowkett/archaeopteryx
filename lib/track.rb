module Archaeopteryx
  class Track < Mix
    attr_accessor :current
    def initialize(attributes)
      @rhythms = attributes[:rhythms]
      @measure = 1
      new_clip
    end
    def new_clip
      @current = @rhythms.random
    end
    def messages(measure)
      @current.messages(measure)
    end
  end
end
