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
        (1..$measures).each do |measure|
          @generator.mutate(measure)
          (0..(@beats - 1)).each do |beat|
            play @generator.notes(beat)
            @clock.tick
          end
        end
        @midi.timer.at((@clock.start + @clock.time) - @evil_timer_offset_wtf, &generate_beats)
      end
      generate_beats[]
      if Platform::IMPL == :mswin
        puts 'Press CTRL-C to stop'
        sleep(10000)
      else
        gets
      end
    end
  end
end
