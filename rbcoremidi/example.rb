require 'coremidi'
require 'midi_in'

# Start archaeopteryx 
# Start GarageBand (just to make sure it's all working)

# Open MIDI Patch Bay.app
# Create a new input (anyname)
# Create a new output (anyname)
# GarageBand will announce that it has found a new input
# You should have sound, yay

# Now run this script

midi_in = MidiIn.new
midi_in.scan
midi_in.link(0)
midi_in.capture {|data| puts data.inspect}
