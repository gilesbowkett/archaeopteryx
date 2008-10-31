probabilities = {}

probabilities[:none] = [0.0] * 16
probabilities[:all] = [1.0] * 16

probabilities[36] = [0.23, 0.0, 0.0, 0.0, 0.0, 0.0, 0.23, 0.0, 0.0, 0.0, 0.0, 0.0, 0.23, 0.0, 0.0, 0.0]
probabilities[37] = [0.0, 0.0, 0.0, 0.0, 0.23, 0.0, 0.0, 0.0, 0.0, 0.0, 0.23, 0.0, 0.0, 0.0, 0.0, 0.0]
probabilities[38] = [0.2, 0.0, 0.3, 0.0, 0.3, 0.1, 0.3, 0.4, 0.0, 0.0, 0.2, 0.0, 0.4, 0.0, 0.0, 0.0]
probabilities[39] = [0.3, 0.0, 0.2, 0.6, 0.1, 0.0, 0.4, 0.1, 0.35, 0.15, 0.0, 0.0, 0.2, 0.0, 0.1, 0.0]
probabilities[40] = [0.0, 0.0, 0.2, 0.0, 0.4, 0.0, 0.0, 0.0, 0.2, 0.0, 0.3, 0.0, 0.3, 0.1, 0.3, 0.4]
probabilities[41] = [0.32, 0.0, 0.23, 0.0, 0.0, 0.0, 0.23, 0.0, 0.15, 0.0, 0.15, 0.0, 0.29, 0.0, 0.15, 0.0]
probabilities[42] = [0.23, 0.0, 0.13, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.13, 0.0, 0.23, 0.0, 0.0, 0.35, 0.0]
probabilities[43] = [0.3] * 16
probabilities[44] = [0.15] * 16
probabilities[45] = [0.32, 0.23] * 8

def note(midi_note_number, channel)
  Note.create(:channel => channel,
              :number => midi_note_number,
              :duration => 0.25,
              :velocity => 100 + rand(27))
end

notes = []
if rand > 0.75
  (36..45).each do |midi_note_number|
    notes << Drum.new(:note => note(midi_note_number, 4),
                      :when => L{|beat| false},
                      :number_generator => L{rand},
                      :next => L{|queue| queue[rand(queue.size)]},
                      :probabilities => probabilities[midi_note_number] || probabilities[:none])
  end
end
notes

[]
