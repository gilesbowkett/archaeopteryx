# cycle through the circle of fifths

require 'lib/archaeopteryx'

$clock = Clock.new(30)
$mutation = L{|measure| 0 == (measure - 1) % 2}
$measures = 4

@loop = Arkx.new(:clock => $clock, # rename Arkx to Loop
                 :measures => $measures,
                 :logging => false,
                 :evil_timer_offset_wtf => 0.2,
                 :generator => Mix.new(:rhythms => [Rhythm.new(:drumfile => "live/db_drum_definition.rb",
                                                               :mutation => $mutation),
                                                    Rhythm.new(:drumfile => "live/harmonic_cycle.rb",
                                                               :mutation => L{|measure| 0 == (measure - 1) % 16}),]))
                                                    # Rhythm.new(:drumfile => "forest_sounds.rb",
                                                    #            :mutation => L{|measure| 0 == (measure - 1) % 16}),
                                                    # Rhythm.new(:drumfile => "ethniq.rb",
                                                    #            :mutation => L{|measure| 0 == (measure - 1) % 16})]))
@loop.go


# also, play random atmospheric samples
