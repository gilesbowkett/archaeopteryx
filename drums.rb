require 'lib/archaeopteryx'

@loop = Loop.new(:clock => Clock.new(170),
                 :measures => 4,
                 :logging => false,
                 :evil_timer_offset_wtf => 0.2,
                 :generator => Rhythm.new(:drumfile => "db_drum_definition.rb",
                                          :mutation => L{|measure| 0 == (measure - 1) % 2}))
@loop.go
gets
