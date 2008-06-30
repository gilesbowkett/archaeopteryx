module Archaeopteryx
  class RhythmWithoutEval
    def initialize(attributes)
      @mutation = attributes[:mutation]
      @drums = attributes[:drums]
    end
    def notes(beat)
      drums = []
      @drums.each do |drum|
        drums << drum.note if drum.play? beat
      end
      drums
    end
    def mutate(measure)
      if @mutation[measure]
        @drums.each {|drum| drum.mutate}
      end
    end
  end
end
