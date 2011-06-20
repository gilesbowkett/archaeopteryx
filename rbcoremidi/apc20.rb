require File.dirname(__FILE__) + '/coremidi'
require File.dirname(__FILE__) + '/midi_in'

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
(0..15).to_a.each {|n| midi_in.link(n)}
# midi_in.capture {}
$wtf = midi_in

# send messages back to the APC to control its LEDs:
# (via http://www.cycling74.com/forums/topic.php?id=20355#post-106507)

# The top left button on the 5x8 clip control grid is 144 53 1, where 144-151 is the entire top horizontal row, 53-57 is the vertical row going down (the next row down in this case is 54), and 1 is the velocity. The bottom Clip Stop row is 52.

# The Velocities are as follows
# 1 - Green
# 2 - Green Flashing
# 3 - Red
# 4 - Red Flashing
# 5 - Orange
# 6 - Orange Flashing

# 7-127 Are all green.

# also to make the transport controls usable, all you have to do is a) isolate the first packet in each
# transport control's set (transport controls send four packets at a time), b) only accept input from
# the particular [a, b, c] values in that first packet, and c) disregard any extraneous packets, especially
# of length greater than three.

# specifically:

# packet [176, 16, 0]
# packet [176, 17, 0]
# packet [176, 18, 0]
# packet [176, 19, 0, 176, 20, 0, 176, 21, 0, 176, 22, 0, 176, 23, 0]

# packet [177, 16, 0]
# packet [177, 17, 0]
# packet [177, 18, 0]
# packet [177, 19, 0, 177, 20, 0, 177, 21, 0, 177, 22, 0, 177, 23, 0]

# in the above real-world data, you would watch for [176, 16, anything] and [177, 16, anything], and
# disregard the rest as noise.

# similarly, although you can't really do much with that stupid dial, you can at least watch for the
# presence of its unique packet signature.

# packet [176, 47, 127]

# the third value is useless, and all you can really measure here is the absence or presence of the
# signal, but a binary signal is still a signal.

# that means you have 63 punch buttons, a dial acting as a 64th punch button, 24 latch buttons, and
# 9 sliders.

# it may be smart to make some signals real-time. breakbeat composition should probably retain its
# tiny lag factor, but things like filters and EQ work better live. that way you also get to keep
# the current algorithmic composition strategy, without having to rethink that stuff (because that
# stuff was fucking hard to figure out), yet you also get to have the spontaneity of live performance.

# obviously also you can use the latch/toggle buttons to toggle slider functionality, but there's a risk
# there of overcomplication. likewise obviously, you can map these controls directly to the audio software,
# or use them to trigger various algorithms. it'd be fun, although very time-consuming, to set them up to
# trigger gradual processes such as filter sweeps or patch morphs (e.g., a techno-esque square wave bass
# morphing into a hoover, or the filter morphing in Underworld "Juanita").

# probably worth the effort.

