module Archaeopteryx
  class Rhythm
    def initialize(attributes)
      # @mutation = attributes[:mutation]
      @drumfile = attributes[:drumfile]
      @flash = attributes[:flash] || (RUBY_PLATFORM.include? 'darwin')
      reload
    end
    def reload
      # flash the screen ; only valid on my box and similarly configured machines!
      puts "\a"  if @flash                    
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

# probably rename this to make it drum-specific
