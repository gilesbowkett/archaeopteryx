$clock.bpm = 5

probabilities = {}

probabilities[:none] = [0.0] * 16
probabilities[:all] = [1.0] * 16

# hip-hop
# probabilities[36] = [1.0, 0.0, 0.5, 0.25, 0.0, 0.6, 0.0, 0.9, 0.9, 0.0, 1.0, 0.0, 0.5, 0.0, 0.3, 0.0]
# probabilities[37] = [0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.0, 1.0, 0.0, 0.0, 0.0]

# d&b
probabilities[36] = [1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0]
probabilities[37] = [0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0]

# both
probabilities[38] = [0.2, 0.0, 0.3, 0.0, 0.3, 0.1, 0.3, 0.4, 0.0, 0.0, 0.2, 0.0, 0.4, 0.0, 0.0, 0.0]
probabilities[39] = [0.3, 0.0, 0.2, 0.6, 0.1, 0.0, 0.4, 0.1, 0.35, 0.15, 0.0, 0.0, 0.2, 0.0, 0.1, 0.0]
probabilities[40] = [0.0, 0.0, 0.2, 0.0, 0.4, 0.0, 0.0, 0.0, 0.2, 0.0, 0.3, 0.0, 0.3, 0.1, 0.3, 0.4]
probabilities[41] = [0.76, 0.0, 0.23, 0.0, 0.0, 0.0, 0.67, 0.0, 0.15, 0.0, 0.15, 0.0, 0.49, 0.0, 0.15, 0.0]
probabilities[42] = [0.75, 0.0, 0.13, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.13, 0.0, 0.23, 0.0, 0.0, 0.35, 0.0]
probabilities[43] = [0.9] * 16
probabilities[44] = [0.65] * 16
probabilities[45] = [0.85, 0.35] * 8

# 0 DO NOT USE!
# 1 distorted Roni Size
# 2 Roni Size
# 3 idm
# 4 Trent Reznor
# [2,5][rand(2)] hip-hop
# 6 Zed
# ((1..6).to_a)[rand(6)] madness

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
                    # :number_generator => L{0.3},
                    # :next => L{|queue| queue[queue.size - 1]},
                    :number_generator => L{rand},
                    :next => L{|queue| queue[rand(queue.size)]},
                    :probabilities => probabilities[midi_note_number] || probabilities[:none])
end
notes
