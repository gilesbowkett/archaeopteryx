module Archaeopteryx
  class Rhythm
    def initialize(attributes)
      # @mutation = attributes[:mutation]
      @drumfile = attributes[:drumfile]
      reload
    end
    def flash_screen
      puts "\a" if Platform::IMPL == :macosx
    end
    def reload
      flash_screen
      @drums = eval(File.read(@drumfile))
    end
    def notes(beat)
      drums = []
      @drums.each do |drum|
        drums << drum.note if drum.play? beat
      end
      drums
    end
    def mutate(measure)
      if $mutation[measure]
        reload # reloading can kill mutations!
        @drums.each {|drum| drum.mutate}
      end
    end
  end
end
