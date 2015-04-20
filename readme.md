Alpha! Not release-ready! Here be dragonnes! etc.

Archaeopteryx is a MIDI system for Ruby. Archaeopteryx uses MIDIator for MIDI Out and recommends rbcoremidi for MIDI In.

Archaeopteryx is a collection of hacks, some living on their own branches, many of them ugly. The best-known is a probabilistic step sequencer. Other Archaeopteryx hacks tour the circle of fifths and the circle of fourths, do extremely simplistic randomized pseudo-arpeggios, handle chord progressions of the I-IV-V and V-I varieties, synch the probabilistic step sequencer to MP3 playback, automate Ableton Live to create random, brainless "DJ mixes," and crossfade between existing MP3 tracks.

Archaeopteryx differs from projects like ChucK, Supercollider, PD, Max/MSP and OSC in a fundamental way. Archaeopteryx favors simplicity over power, and ubiquitous protocols over any other kind. Archaeopteryx does not want programmatic control over sound or audio. Archaeopteryx exists because music software should have a scriptable command-line interface. Archaeopteryx aspires to be an MPC-2000 with a shell prompt. You use Archaeopteryx as a Ruby front-end to music software such as Propellerhead Reason and Ableton Live.

Consequently you need a MIDI consumer to get anything useful out of Archaeopteryx. The wiki links to two videos which show you how to drive GarageBand with Arx. Arx also includes a simple MIDI consumer written in ChucK which allows programmers to operate Arx's probabilistic step sequencer without being required to buy anything or learn any unfamiliar software. That is, unless you count the ChucK interpreter. Install it here:

  http://chuck.cs.princeton.edu/release/

To use it, first get the consumer running:

  ~/programming/chuck/bin/chuck demo.ck &

Next drive it with the probabilistic step sequencer:

  ruby eval_style.rb

Voila.

The drum samples for demo.ck came from SampleSwap:

  http://www.sampleswap.org/index.php

