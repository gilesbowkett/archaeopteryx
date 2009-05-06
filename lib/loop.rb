module Archaeopteryx
  class Loop
    attr_reader :midi
    def initialize(attributes)
      %w{generator measures beats clock midi evil_timer_offset_wtf}.each do |option|
        eval("@#{option} = attributes[:#{option}]")
      end
      @generate_beats = L do
        (1..@measures).each do |measure|
          @generator.mutate(measure)
          (0..(@beats - 1)).each do |beat|
            play @generator.notes(beat)
            @clock.tick
          end
        end
        @midi.timer.at((@clock.start + @clock.time) - @evil_timer_offset_wtf, &@generate_beats)
      end
    end
    def play(music)
      music.each {|note| @midi.play(note)}
    end
    def go
      @generate_beats[]
    end
  end
end
