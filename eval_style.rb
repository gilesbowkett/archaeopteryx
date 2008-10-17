require 'lib/archaeopteryx'

@sixteen = Arkx.new(:clock => Clock.new(170), # rename Arkx to Loop
                    :measures => 4,
                    :logging => false,
                    :evil_timer_offset_wtf => 0.2,
                    :generator => Mix.new(:rhythms => [Rhythm.new(:drumfile => "sixteen.rb",
                                                                  :mutation => L{|measure| 0 == (measure - 1) % 2}),
                                                       Rhythm.new(:drumfile => "twenty_four.rb",
                                                                  :mutation => L{|measure| 0 == (measure - 1) % 3},
                                                                  :beats => 24)]))

@sixteen.go

gets
