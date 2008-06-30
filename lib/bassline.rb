module Archaeopteryx
  class Bassline
    def initialize(attributes)
      @mutation = attributes[:mutation]
      @drumfile = attributes[:drumfile]
      reload
    end
    def reload
      @drums = eval(File.read(@drumfile))
    end
    def mutate(measure)
      if @mutation[measure]
        reload # reloading can kill mutations!
        @drums.each {|drum| drum.mutate}
      end
    end
    def notes(beat)
      @drums.each do |drum|
        if drum.play? beat
          return drum.note
        end
      end
      [] # I can't tell if this is a bug or a feature. lispy listiness requires return empty list.
    end
  end
end


