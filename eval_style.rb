require 'lib/archaeopteryx'

Arkx.new(:clock => Clock.new(167),
         :measures => 4,
         :logging => true,
         :evil_timer_offset_wtf => 0.2,
         :generator => Rhythm.new(:drumfile => "db_drum_definition.rb",
                                  :mutation => L{|measure| 0 == (measure - 1) % 2})).go
