module Archaeopteryx
  module Midi
    module PracticalRubyProjects
      class LiveMIDI
        
        # this object is a gateway between the Objective-C extern-ed functions from the CoreMIDI API
        # and good old-fashioned Ruby. As such some of the code gets weird. This is nearly all from
        # Topher Cyll's wicked book referenced in the MIT license file (practical_ruby_projects.rb),
        # but with some refactoring and modification.
        
        include CoreMIDI
        include CoreFoundation

        attr_reader :interval # this is a totally misleading variable name! real interval lives on Clock
        attr_reader :timer
        ON = 0x90
        OFF = 0x80
        PC = 0xC0 # program change, I think; not actually useable in Propellerhead Reason v3
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
          @timer = Timer.new(@interval/1000)
          open
        end

        def play(midi_note, on_time = @clock.time)
          if @logging
            puts "@midi.play(#{midi_note.to_code}, #{on_time})"
          end
          on_time += @clock.start
          @timer.at(on_time) {note_on(midi_note)}
          @timer.at(on_time + midi_note.duration) {note_off(midi_note)}
        end
        
        def send(message)
          send_controller_message(message.midi_channel, message.controller_number, message.value)
        end
        def send_controller_message(midi_channel, controller_number, value, on_time = @clock.time)
          on_time += @clock.start
          puts "scheduling #{controller_number} for #{on_time}" if @logging
          @timer.at(on_time) do
            control(midi_channel, controller_number, value)
          end
        end

        def open
          client_name = CoreFoundation.cFStringCreateWithCString(nil, "RubyMIDI", 0)
          @client = DL::PtrData.new(nil)
          CoreMIDI.mIDIClientCreate(client_name, nil, nil, @client.ref)

          port_name = CoreFoundation.cFStringCreateWithCString(nil, "Output", 0)
          @outport = DL::PtrData.new(nil)
          CoreMIDI.mIDIOutputPortCreate(@client, port_name, @outport.ref)

          number_of_destinations = CoreMIDI.mIDIGetNumberOfDestinations()
          raise NoMIDIDestinations if number_of_destinations < 1
          @destination = CoreMIDI.mIDIGetDestination(@midi_destination)
        end

        def close
          CoreMIDI.mIDIClientDispose(@client)
        end
        
        def clear
          @timer.flush
        end

        def message(*args)
          format = "C" * args.size
          bytes = args.pack(format).to_ptr
          packet_list = DL.malloc(256)
          packet_ptr = CoreMIDI.mIDIPacketListInit(packet_list)
          packet_ptr = CoreMIDI.mIDIPacketListAdd(packet_list, 256, packet_ptr, 0, 0, args.size, bytes)
          CoreMIDI.mIDISend(@outport, @destination, packet_list)
        end

        def note_on(midi_note)
          message(ON | midi_note.channel, midi_note.number, midi_note.velocity)
        end

        def note_off(midi_note)
          message(OFF | midi_note.channel, midi_note.number, midi_note.velocity)
        end

        def program_change(channel, preset)
          message(PC | channel, preset)
        end
        
        def pulse(channel, controller_id, value)
          # puts "sending now: #{Time.now.to_f}" if @logging
          # puts "#{[channel, controller_id, value].inspect}" if @logging
          message(CONTROLLER | channel, controller_id, value)
        end
        alias :control :pulse
      end
    end
  end
end
