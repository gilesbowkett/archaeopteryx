module Archaeopteryx
  class ScaleTraversalRhythm
    def initialize(attributes)
      @mutation = attributes[:mutation]
      @arpeggio = attributes[:arpeggio]
      @scale = attributes[:scale]
    end
    def map
      @drums = @scale / arpeggio
    end
    def notes(beat)
      drums = []
      @drums.each do |drum|
        drums << drum.note if drum.play? beat
      end
      drums
    end
    def mutate(measure)
      map if @mutation[measure]
    end
  end
end
