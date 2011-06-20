require 'coremidi'
require 'midi_in'
require 'rubygems'
require 'active_support'

midi_in = MidiIn.new
midi_in.scan
midi_in.link(0)

midi_in.capture do |messages|
  messages.each do |message|
    next unless message.respond_to? :note_number
    system("open http://boingboing.net") if 60 == message.note_number
  end
end

