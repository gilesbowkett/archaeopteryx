twenty_four = {}
twenty_four[41] = [0.76, 0.0, 0.23, 0.0, 0.0, 0.0, 0.67, 0.0] * 3
twenty_four[42] = [0.75, 0.13, 0.13] * 8
twenty_four[43] = [0.9] * 24
twenty_four[44] = [0.65] * 24
twenty_four[45] = [0.85, 0.35, 0.15] * 8

probabilities = twenty_four

def note(midi_note_number)
  Note.create(:channel => 2,
              :number => midi_note_number,
              :duration => 0.25,
              :velocity => 100 + rand(27))
end

notes = []
(41..45).each do |midi_note_number|
  notes << Drum.new(:note => note(midi_note_number),
                    :when => L{|beat| false},
                    # :number_generator => L{0.8},
                    # :next => L{|queue| queue[queue.size - 1]},
                    :number_generator => L{rand},
                    :next => L{|queue| queue[rand(queue.size)]},
                    :probabilities => probabilities[midi_note_number] || probabilities[:none])
end
notes
