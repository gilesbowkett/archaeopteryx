require 'lib/archaeopteryx'

$clock = Clock.new(170)

@loop = Arkx.new(:clock => $clock, # rename Arkx to Loop
                 :measures => 4,
                 :logging => false,
                 :evil_timer_offset_wtf => 0.2,
                 :generator => Rhythm.new(:drumfile => "db_drum_definition.rb",
                                          :mutation => L{|measure| 0 == (measure - 1) % 2}))
@loop.go
