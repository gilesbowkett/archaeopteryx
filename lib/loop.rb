module Archaeopteryx
  class Loop
    attr_reader :midi
    def initialize(attributes)
      %w{generator
         measures
         beats
         clock
         midi
         evil_timer_offset_wtf
         infinite}.each do |option|
        eval("@#{option} = attributes[:#{option}]")
      end
    end
    def generate_beats
      (1..@measures).each do |measure|
        @generator.mutate(measure)
        (0..(@beats - 1)).each do |beat|
          play @generator.notes(beat)
          @clock.tick
        end
      end
      if @midi.infinite?
        @midi.timer.at((@clock.start + @clock.time) - @evil_timer_offset_wtf,
                       &(L{generate_beats}))
      end
    end
    def play(music)
      music.each {|note| @midi.play(note)}
    end
  end
end
