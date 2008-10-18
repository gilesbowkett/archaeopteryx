# usage: ruby text2tone.rb muppets

require 'lib/archaeopteryx'

clock = Clock.new(101)
midi = LiveMIDI.new(:clock => clock, :logging => false)

def note(midi_note_number)
  Note.create(:channel => 0,
              :number => midi_note_number,
              :duration => 0.25,
              :velocity => 100 + rand(27))
end


file = ARGV[0]
base_note = 60 # middle C

File.new(file).each_line do |line|
  line.split.each do |word|
    midi.play(note(base_note + word.length))
    clock.tick
  end
end

while true
  gets
end
