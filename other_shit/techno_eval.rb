require 'lib/archaeopteryx'


glass_probabilities = {}

glass_probabilities[:none] = [0.0] * 16
glass_probabilities[:all] = [1.0] * 16

glass_probabilities[:maybe] = [0.67] + ([0.0] * 15)

def glass_note(midi_note_number)
  Note.create(:channel => 1,
              :number => midi_note_number,
              :duration => 1.67,
              :velocity => 50 + rand(77))
end

glass_notes = []
(36..45).each do |midi_note_number|
  glass_notes << Drum.new(:note => glass_note(midi_note_number),
                          :when => L{|beat| false},
                          :number_generator => L{rand},
                          :next => L{|queue| queue[queue.size - 1]},
                          :probabilities => glass_probabilities[midi_note_number] || glass_probabilities[:maybe])
end




Arkx.new(:clock => Clock.new(140),
         :measures => 32,
         :evil_timer_offset_wtf => 4.0,
         :generator => Mix.new(:rhythms => [Rhythm.new(:drumfile => "def_techno.rb",
                                                       :mutation => L{|measure| 0 == (measure - 1) % 16}),
                                            Bassline.new(:drums => glass_notes,
                                                         :mutation => L{|measure| 0 == (measure - 1) % 24})
                                           ])).go # Ruby can get Lispy fast

