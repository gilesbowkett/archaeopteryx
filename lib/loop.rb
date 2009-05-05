module Archaeopteryx
  class Loop
    attr_reader :midi
    def initialize(attributes)
      @generator = attributes[:generator]
      @measures = attributes[:measures] || 32
      @beats = attributes[:beats] || 16
      @evil_timer_offset_wtf = attributes[:evil_timer_offset_wtf]
      @clock = attributes[:clock] # lame, DRY
      @midi = attributes[:midi] # lame, DRY (heh)
    end
    def play(music)
      music.each {|note| @midi.play(note)}
    end
    def go
      generate_beats = L do
        (1..@measures).each do |measure|
          @generator.mutate(measure)
          (0..(@beats - 1)).each do |beat|
            play @generator.notes(beat)
            @clock.tick
          end
        end
        @midi.timer.at((@clock.start + @clock.time) - @evil_timer_offset_wtf, &generate_beats)
      end
      generate_beats[]
    end
  end
end
