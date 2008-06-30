module Archaeopteryx
  class Sequence
    attr_accessor :current
    def initialize(attributes)
      @measures = attributes[:measures]
      @array = attributes[:array]
      @ceiling = @array.size - 1
      @current = -1
      @floor = 0
    end
    def notes(beat)
      @array[@current][].notes(beat)
    end
    def mutate(measure)
      return unless 0 == (measure - 1) % @measures
      if @current < @ceiling
        @current += 1
      else
        @current = @floor
      end
    end
  end
end
