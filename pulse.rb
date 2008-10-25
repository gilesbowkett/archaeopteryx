require 'lib/archaeopteryx'

# use this script to tell Ableton which controllers are going to handle which controls

@live_midi = LiveMIDI.new(:logging => false,
                          :clock => Clock.new(167))

channel = ARGV[0].to_i
controller = ARGV[1].to_i

@live_midi.pulse(channel, controller, 0) # channel, controller, value
sleep 1
@live_midi.pulse(channel, controller, 100)

















# the dank dark pit of comment cruft

# tap tempo
# @live_midi.pulse(15, 7, 0) # channel, controller, value
# sleep 1
# @live_midi.pulse(15, 7, 100)

# doc ock
# @live_midi.pulse(0, 9, 0)
# sleep 1
# @live_midi.pulse(0, 9, 100)
# 

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
