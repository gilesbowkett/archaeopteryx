probabilities = {}

probabilities[:none] = [0.0] * 16
probabilities[:all] = [1.0] * 16

probabilities[36] = [1.0, 0.0, 0.0, 0.0] * 4
probabilities[37] = ([0.0] * 4 + [1.0] + [0.0] * 3) * 2
probabilities[38] = [0.8, 0.0, 0.3, 0.0] * 4
probabilities[39] = [0.0, 0.3, 0.0, 0.2, 0.6, 0.1, 0.0, 0.4, 0.1, 0.35, 0.15, 0.0, 0.0, 0.2, 0.0, 0.1]
probabilities[40] = [0.01, 0.05] * 16
probabilities[41] = [0.96] * 16
probabilities[42] = [0.0, 0.0, 0.75, 0.0, 0.13, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.13, 0.0, 0.23, 0.0, 0.0]
probabilities[43] = [0.3] * 16
probabilities[44] = [0.65] * 16
probabilities[45] = [0.0, 0.0, 0.67, 0.0, 0.25] * 3 + [0.0, 0.1, 0.0]

def note(midi_note_number)
  Note.create(:channel => 3,
              :number => midi_note_number,
              :duration => 0.25,
              :velocity => 100 + rand(27))
end

notes = []
(36..45).each do |midi_note_number|
  notes << Drum.new(:note => note(midi_note_number),
                    :when => L{|beat| false},
                    # :number_generator => L{rand},
                    # :next => L{|queue| queue[queue.size - 1]},
                    :number_generator => L{rand},
                    :next => L{|queue| queue[rand(queue.size)]},
                    :probabilities => probabilities[midi_note_number] || probabilities[:none])
end
notes
