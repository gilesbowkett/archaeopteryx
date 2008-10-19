module Archaeopteryx
  class Rhythm
    def initialize(attributes)
      # @mutation = attributes[:mutation]
      @drumfile = attributes[:drumfile]
      reload
    end
    def reload
      puts "\a" # flash the screen ; only valid on my box and similarly configured machines!
      @drums = eval(File.read(@drumfile))
    end
    def notes(beat)
      drums = []
      @drums.each do |drum|
        drums << drum.note if drum.play? beat
      end
      drums
    end
    def messages(beat)
      []
    end
    def mutate(measure)
      if $mutation[measure]
        reload # reloading can kill mutations!
        @drums.each {|drum| drum.mutate}
      end
    end
  end
end

# probably rename this to make it drum-specific
