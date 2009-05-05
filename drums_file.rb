require 'lib/archaeopteryx'

@clock = Clock.new(170)

@loop = Loop.new(:clock => @clock,
                 :measures => 4,
                 :logging => false,
                 :evil_timer_offset_wtf => 0.2,
                 :midi => FileMIDI.new(@clock),
                 :generator => Rhythm.new(:drumfile => "db_drum_definition.rb",
                                          :mutation => L{|measure| 0 == (measure - 1) % 2}))
@loop.go
gets
