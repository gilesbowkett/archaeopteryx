


probabilities = {}

probabilities[:none] = [0.0] * 16
probabilities[:all] = [1.0] * 16

probabilities[36] = [1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0]
probabilities[37] = [0.0, 0.0, 0.0, 0.0, 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.9, 0.0, 0.9, 0.0, 0.0]
probabilities[38] = [0.0, 0.0, 0.2, 0.0, 0.3, 0.0, 0.73, 0.1, 0.3, 0.1, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0]
probabilities[39] = [0.0, 0.0, 0.2, 0.0, 0.5, 0.0, 0.3, 0.1, 0.1, 0.71, 0.0, 0.72, 0.2, 0.0, 0.0, 0.0]
probabilities[40] = [0.0, 0.0, 0.5, 0.0] * 4
probabilities[41] = [0.0, 0.76, 0.0, 0.23, 0.0, 0.0, 0.0, 0.67, 0.0, 0.15, 0.0, 0.15, 0.0, 0.49, 0.0, 0.15]
probabilities[42] = [0.0, 0.75, 0.0, 0.13, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.13, 0.0, 0.23, 0.0, 0.0, 0.35]
probabilities[43] = [0.8, 0.0] * 8
probabilities[44] = [0.65] * 16
probabilities[45] = [0.0, 0.15, 0.35, 0.0] * 8




# alt rhythm
alt = {}
alt[36] = [1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0]
alt[37] = [0.0, 0.0, 0.2, 0.0, 0.9, 0.0, 0.2, 0.5, 0.0, 0.0, 0.0, 0.9, 0.5, 0.1, 0.7, 0.0]
alt[38] = [0.2, 0.3, 0.0, 0.5] * 4
alt[39] = [0.0, 0.5, 0.7, 0.5] * 4
alt[40] = [0.0, 0.0, 0.8, 0.0] * 4
alt[41] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.13, 0.0, 0.23, 0.0, 0.0, 0.35, 0.0, 0.75, 0.0, 0.13]
alt[42] = [0.3, 0.2, 0.0, 0.67, 0.0, 0.15, 0.0, 0.15, 0.2, 0.49, 0.2, 0.15, 0.0, 0.76, 0.0, 0.23]
alt[43] = [0.0, 0.05, 0.35, 0.2] * 8
alt[44] = [0.0, 0.25] * 8
alt[45] = [0.65] * 16

probabilities = alt

# 0 DO NOT USE!
# 1 80s 909
# 2 aggro
# 3 909
# 4 trebly aggro
# ((1..4).to_a)[rand(4)] all drum kits

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
                    :number_generator => L{0.8},
                    :next => L{|queue| queue[queue.size - 1]},
                    # :number_generator => L{rand},
                    # :next => L{|queue| queue[rand(queue.size)]},
                    :probabilities => probabilities[midi_note_number] || probabilities[:none])
end
notes
