require 'lib/archaeopteryx'

@loop = Loop.new(:measures => 32,
                 :beats => 16,
                 :logging => false,
                 :evil_timer_offset_wtf => 0.2,
                 :clock => (@clock = Clock.new(@tempo = 170)),
                 :midi => (@midi = FileMIDI.new(:tempo => @tempo,
                                                :clock => @clock,
                                                :filename => "db_drums.midi",
                                                :name => "d&b drums")),
                 :generator => Rhythm.new(:drumfile => "db_drum_definition.rb",
                                          :mutation => L{|measure| 0 == (measure - 1) % 2}))
@loop.generate_beats
@midi.write
