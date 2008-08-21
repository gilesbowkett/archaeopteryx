glass_probabilities = {}

glass_probabilities[:never] = [0.0] * 16
glass_probabilities[:once] = [1.0] + ([0.0] * 15)
glass_probabilities[:maybe] = [0.67] + ([0.0] * 15)

def glass_note(midi_note_number, channel)
  Note.create(:channel => [0,5][rand(2)],
              :number => midi_note_number,
              :duration => 3.67,
              :velocity => 50 + rand(77))
end

glass_notes = []
(36..45).each do |midi_note_number|
  glass_notes << Drum.new(:note => glass_note(midi_note_number, 0),
                          :when => L{|beat| false},
                          :number_generator => L{rand},
                          :next => L{|queue| queue[queue.size - 1]},
                          :probabilities => glass_probabilities[midi_note_number] || glass_probabilities[:once])
end

glass_notes
