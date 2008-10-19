require 'rubygems'
require 'midiator'

module Archaeopteryx
  module Midi
    # this object wraps MIDIator's interface with some extra awesomeness
    class LiveMIDI
      attr_reader :interval # this is a totally misleading variable name! real interval lives on Clock
      attr_reader :timer

      CONTROLLER = 0xB0 # arbitrary controller message

      def to_code
        "LiveMIDI.new(:clock => @clock = attributes[:clock], :logging => false)"
      end

      def initialize(options)
        @clock = options[:clock]
        @logging = options[:logging]
        @midi_destination = options[:midi_destination] || 0
        if @logging
          puts <<LOG_PLAYBACK
require 'lib/archaeopteryx'
@midi = #{self.to_code}
LOG_PLAYBACK
        end
        @interval = 60.0/120 # this is just a polling interval for the Thread - not a musical one
        @timer = MIDIator::Timer.new(@interval/1000)
        @interface = MIDIator::Interface.new
        @interface.autodetect_driver
      end

      def play(midi_note, on_time = @clock.time)
        if @logging
          puts "@midi.play(#{midi_note.to_code}, #{on_time})"
        end
        on_time += @clock.start
        @timer.at(on_time) {note_on(midi_note)}
        @timer.at(on_time + midi_note.duration) {note_off(midi_note)}
      end
      
      def send_controller_message(midi_channel, controller_number, value, on_time = @clock.time)
        on_time += @clock.start
        # puts "scheduling for #{on_time}" if @logging
        @timer.at(on_time) do
          control(midi_channel, controller_number, value)
        end
      end

      def note_on(midi_note)
        @interface.note_on( midi_note.number, midi_note.channel, midi_note.velocity )
      end

      def note_off(midi_note)
        @interface.note_off( midi_note.number, midi_note.channel, midi_note.velocity )
      end

      def program_change(channel, preset)
        @interface.program_change( channel, preset )
      end
      
      def pulse(channel, controller_id, value)
        # puts "sending now: #{Time.now.to_f}" if @logging
        # puts "#{[channel, controller_id, value].inspect}" if @logging
        @interface.message(CONTROLLER | channel, controller_id, value)
      end
      alias :control :pulse
    end
  end
end
