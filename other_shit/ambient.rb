require 'lib/archaeopteryx'

require 'rubyfringe'



Arkx.new(:clock => Clock.new(23),
         :measures => 64,
         :logging => true,
         :evil_timer_offset_wtf => 4.0,
         :generator => Mix.new(:rhythms => [Rhythm.new(:drumfile => "def_ambient.rb",
                                                       :mutation => L{|measure| 0 == (measure - 1) % 16}),
                                            Bassline.new(:drumfile => "ambient_low.rb",
                                                         :mutation => L{|measure| 0 == (measure - 1) % 32}),
                                            Bassline.new(:drumfile => "ambient_high.rb",
                                                         :mutation => L{|measure| 0 == (measure - 1) % 24})
                                           ])).go # Ruby can get Lispy fast




# ok this needs: a system to move the notes through the circle of fifths; a system to restrict notes
# within a given scale which changes as the notes move through the circle of fifths; and real drum rhythms,
# i.e., ones that actually sound good in the context of all this stuff.

# probably a system similar to the current system for Rhythms and RhythmWithoutEvals (which should probably
# be the same things, just using different lambdas). just in the mutate method, get your scale from the
# scale generator, and the scale generator knows where it is in the circle of fifths and has some
# independent, long-running cycle for moving through that circle.
