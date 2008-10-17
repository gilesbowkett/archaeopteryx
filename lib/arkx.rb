module Archaeopteryx
  class Arkx
    def initialize(attributes)
      @generator = attributes[:generator]
      # @measures = attributes[:measures] || 32
      @beats = attributes[:beats] || 16
      midi_destination = attributes[:midi_destination] || 0
      @evil_timer_offset_wtf = attributes[:evil_timer_offset_wtf]
      @midi = LiveMIDI.new(:clock => @clock = attributes[:clock], # confusion!!!!!!!!!!
                           :logging => attributes[:logging] || false,
                           :midi_destination => midi_destination)
    end
    def play(music)
      music.each {|note| @midi.play(note)}
    end
    def go
      generate_beats = L do
        start = @clock.time
        @generator.rhythms.each do |rhythm|
          rhythm.clock.time = start
          (1..4).each do |measure|
            rhythm.mutate(measure)
            (0..(rhythm.beats - 1)).each do |beat|
              play rhythm.notes(beat)
              rhythm.clock.tick
              @clock.time = rhythm.clock.time
            end
          end
          @midi.timer.at((@clock.start + @clock.time) - @evil_timer_offset_wtf, &generate_beats)
        end
      end
      generate_beats[]
    end
  end
end
