$clock.bpm = rand > 0.5 ? 175 : 140
$mutation = L{|measure| 0 == (measure - 1) % 2}
$measures = 4
$beats = rand > 0.5 ? 16 : 9

puts $beats

four_four = {}
four_four[36] = [1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0]
four_four[37] = [0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0]
four_four[38] = [0.2, 0.0, 0.3, 0.0, 0.3, 0.1, 0.3, 0.4, 0.0, 0.0, 0.2, 0.0, 0.4, 0.0, 0.0, 0.0]
four_four[39] = [0.3, 0.0, 0.2, 0.6, 0.1, 0.0, 0.4, 0.1, 0.35, 0.15, 0.0, 0.0, 0.2, 0.0, 0.1, 0.0]
four_four[40] = [0.0, 0.0, 0.2, 0.0, 0.4, 0.0, 0.0, 0.0, 0.2, 0.0, 0.3, 0.0, 0.3, 0.1, 0.3, 0.4]
four_four[41] = [0.76, 0.0, 0.23, 0.0, 0.0, 0.0, 0.67, 0.0, 0.15, 0.0, 0.15, 0.0, 0.49, 0.0, 0.15, 0.0]
four_four[42] = [0.75, 0.0, 0.13, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.13, 0.0, 0.23, 0.0, 0.0, 0.35, 0.0]
four_four[43] = [0.9] * 16
four_four[44] = [0.65] * 16
four_four[45] = [0.85, 0.35] * 8

three_three = {}
three_three[36] = [1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0]
three_three[37] = [0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0]
three_three[38] = [0.2, 0.0, 0.3, 0.0, 0.3, 0.1, 0.3, 0.4, 0.0]
three_three[39] = [0.3, 0.0, 0.2, 0.6, 0.1, 0.0, 0.4, 0.1, 0.35]
three_three[40] = [0.0, 0.0, 0.2, 0.0, 0.4, 0.0, 0.0, 0.0, 0.2]
three_three[41] = [0.76, 0.0, 0.23, 0.0, 0.0, 0.0, 0.67, 0.0, 0.15]
three_three[42] = [0.75, 0.13, 0.13] * 3
three_three[43] = [0.9] * 9
three_three[44] = [0.65] * 9
three_three[45] = [0.85, 0.35, 0.15] * 3


9 == $beat ? probabilities = three_three : probabilities = four_four

def note(midi_note_number)
  Note.create(:channel => 2,
              :number => midi_note_number,
              :duration => 0.25,
              :velocity => 100 + rand(27))
end

notes = []
(36..45).each do |midi_note_number|
  notes << Drum.new(:note => note(midi_note_number),
                    :when => L{|beat| false},
                    # :number_generator => L{0.8},
                    # :next => L{|queue| queue[queue.size - 1]},
                    :number_generator => L{rand},
                    :next => L{|queue| queue[rand(queue.size)]},
                    :probabilities => probabilities[midi_note_number] || probabilities[:none])
end
notes
