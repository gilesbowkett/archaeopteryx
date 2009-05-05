require 'lib/archaeopteryx'

@loop = Loop.new(:measures => 4,
                 :logging => false,
                 :evil_timer_offset_wtf => 0.2,
                 :clock => Clock.new(@tempo = 170),
                 :midi => FileMIDI.new(:tempo => @tempo,
                                       :filename => "db_drums.midi",
                                       :name => "d&b drums"),
                 :generator => Rhythm.new(:drumfile => "db_drum_definition.rb",
                                          :mutation => L{|measure| 0 == (measure - 1) % 2}))
@loop.go
gets
