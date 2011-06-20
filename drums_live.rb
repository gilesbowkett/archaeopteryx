require 'lib/archaeopteryx'
require 'rbcoremidi/apc20'

@clock = Clock.new(170)

@loop = Loop.new(:clock => @clock,
                 :measures => 4,
                 :beats => 16,
                 :logging => false,
                 :evil_timer_offset_wtf => 0.2,
                 :midi => LiveMIDI.new(:clock => @clock, # meh
                                       :logging => true,
                                       :midi_destination => 0),
                 :generator => Rhythm.new(:drumfile => "db_drum_definition.rb",
                                          :mutation => L{|measure| 0 == (measure - 1) % 2}))
@loop.generate_beats
gets

