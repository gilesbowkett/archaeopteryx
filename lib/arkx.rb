module Archaeopteryx
  class Arkx
    def initialize(attributes)
      @generator = attributes[:generator]
      @measures = attributes[:measures] || 32
      @beats = attributes[:beats] || 16
      @evil_timer_offset_wtf = attributes[:evil_timer_offset_wtf]
      @midi = LiveMIDI.new(:clock => @clock = attributes[:clock], # confusion!!!!!!!!!!
                           :logging => attributes[:logging] || false)
      # doc ock hackery
      @tap_tempo = TapTempo.new
      @faders = []
      (0..9).each do |number|
        @faders[number] = Fader.new
        @faders[number].midi_channel = 0
        @faders[number].controller_number = number
      end
    end
    def play(music)
      music.each {|note| @midi.play(note)}
    end
    def go
      generate_beats = L do
        (1..@measures).each do |measure|
          @generator.mutate(measure)
          (0..(@beats - 1)).each do |beat|
            if [0, 4, 8, 12].include? beat
              @midi.send_controller_message(15, 7, 127) # experimental tap-tempo scheduler
              # this should almost certainly be something like
              #   trigger @generator.messages(beat)
            end
            # globals because I wrote this part on the plane - expect refactoring
            if $lock_live
              if $beat_juggle
                chosen = [$live_channels[rand($live_channels.size)]]
              else
                chosen = $live_channels
              end
              (0..9).each do |channel|
                if chosen.include? channel
                  @faders[channel].value = 100
                  @midi.send_controller_message(@faders[channel].midi_channel,
                                                @faders[channel].controller_number,
                                                @faders[channel].value)
                else
                  @faders[channel].value = 0
                  @midi.send_controller_message(@faders[channel].midi_channel,
                                                @faders[channel].controller_number,
                                                @faders[channel].value)
                end
              end
            end
            play @generator.notes(beat)
            @clock.tick
          end
        end
        @midi.timer.at((@clock.start + @clock.time) - @evil_timer_offset_wtf, &generate_beats)
      end
      generate_beats[]
      gets
    end
  end
end

# there are two or three ways to refactor the tap tempo as far as I can tell.

# 1 pass in a block
# 2 control-message scheduler object
# 3 pass in control messages for scheduling

# 4 control message probability matrix
# 5 control messages *IN* the existing probability matrix
#   trigger @generator.messages(beat)
