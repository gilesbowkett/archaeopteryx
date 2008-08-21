glass_probabilities = {}

glass_probabilities[:never] = [0.0] * 16
glass_probabilities[:once] = [1.0] + ([0.0] * 15)
glass_probabilities[:maybe] = [0.67] + ([0.0] * 15)

def glass_note(midi_note_number)
  Note.create(:channel => [0,1,4,5][rand(4)],
              :number => midi_note_number,
              :duration => 3.67,
              :velocity => 50 + rand(77))
end


moon_notes = []
(82..91).each do |midi_note_number|
  moon_notes << Drum.new(:note => glass_note(midi_note_number),
                         :when => L{|beat| false},
                         :number_generator => L{rand},
                         :next => L{|queue| queue[queue.size - 1]},
                         :probabilities => glass_probabilities[midi_note_number] || glass_probabilities[:once])
end
moon_notes
