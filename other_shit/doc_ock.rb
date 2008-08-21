require 'lib/archaeopteryx'

class Fader
  attr_accessor :midi_channel, :controller_number
  def toggle
    [midi_channel, controller_number, self.next]
  end
  attr_accessor :value
end


class TapTempo
  def midi_channel; 15 ; end
  def controller_number ; 7 ; end
  def value ; 127 ; end
end

class DocOck
  def initialize(attributes)
    @generator = attributes[:generator]
    @measures = attributes[:measures] || 32
    @beats = attributes[:beats] || 16
    @evil_timer_offset_wtf = attributes[:evil_timer_offset_wtf]
    @midi = LiveMIDI.new(:clock => @clock = attributes[:clock], # confusion!!!!!!!!!!
                         :logging => attributes[:logging] || false)
    @tap_tempo = TapTempo.new
    @faders = []
    (0..3).each do |number|
      @faders[number] = Fader.new
      @faders[number].midi_channel = 0
      @faders[number].controller_number = number
    end
  end
  def go
    generate_beats = L do
      (1..@measures).each do |measure|
        (0..(@beats - 1)).each do |beat|
          chosen = rand(4)
          (0..3).each do |number|
            case number
            when chosen
              @faders[number].value = 100
              @midi.send_controller_message(@faders[number].midi_channel,
                                            @faders[number].controller_number,
                                            @faders[number].value)
            else
              @faders[number].value = 0
              @midi.send_controller_message(@faders[number].midi_channel,
                                            @faders[number].controller_number,
                                            @faders[number].value)
            end
          end
          @clock.tick
        end
      end
      @midi.timer.at((@clock.start + @clock.time) - @evil_timer_offset_wtf, &generate_beats)
    end
    generate_beats[]
    gets
  end
end

DocOck.new(:clock => Clock.new(175),
           :evil_timer_offset_wtf => 0.2).go


# so, I need to schedule these motions, just like I would schedule a MIDI note; and also I need to
# apply tweens, to make the motion fluid. I need to support the variety of different control styles
# which Live enables, and I need some way of mapping these things, so that I can accomodate complexity
# in their number and arrangement. I need programmatic control, similar to my Reason live-coding, and
# I need to power the tap tempo button in such a way that I retain my Reason features while hitting
# the absolute bare minimum of complexity in MIDI synch.

# if I get all these things done, I have a combined live-coding package which generates music in
# Reason and Live simultaneously. then you throw the outputs to a hardware mixer and sort it out live
# (no pun intended). at that point there's a use case for cue audio again, so at that point you can
# build a cue setup in Reason and use the cue features in Live as well.
