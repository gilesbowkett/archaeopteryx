require 'lib/archaeopteryx'
require 'incr_drum_definition'

literal_rhythm = RhythmWithoutEval.new(:drums => main_drums,
                                       :mutation => L{|measure| true})
literal_2 = RhythmWithoutEval.new(:drums => alt_drums,
                                  :mutation => L{|measure| true})
dynamically_calculated_fill = L{RhythmWithoutEval.new(:drums => fill_drums,
                                                      :mutation => L{|measure| 0 == (measure - 1) % 2})}
first_rhythm = L{literal_rhythm}
second_rhythm = L{literal_2}

rhythms = [first_rhythm] * 4 +
          [second_rhythm] * 4 +
          [first_rhythm] * 2 + [second_rhythm] * 2 +
          [first_rhythm, second_rhythm, first_rhythm, dynamically_calculated_fill]

Arkx.new(:clock => Clock.new(167),
         :evil_timer_offset_wtf => 0.2,
         # :measures => 4, # this does absolutely fucking nothing!
         :generator => Sequence.new(:array => rhythms,
                                    :measures => 1)).go
