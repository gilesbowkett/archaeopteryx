$clock.bpm = 30
$mutation = L{|measure| 0 == (measure - 1) % 2}
$measures = 4

root = OCTAVES[2].to_a[SCALE[CIRCLE_OF_FIFTHS.next]]
puts root

def note(midi_note_number, channel)
  Note.create(:channel => channel,
              :number => midi_note_number,
              :duration => 3.00,
              :velocity => 100 + rand(27))
end

notes = []
bass = Drum.new(:note => note(root - 36, 1),
                :when => L{|beat| false},
                :next => L{|queue| queue[queue.size - 1]},
                :number_generator => L{rand},
                :probabilities => [1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0])
notes << bass

MAJOR_TRIAD.each do |number|
  notes << Drum.new(:note => note(root + number, 2),
                    :when => L{|beat| false},
                    :next => L{|queue| queue[queue.size - 1]},
                    :number_generator => L{rand},
                    :probabilities => [1.0] + [0.0] * 15)
  end
notes

# def temple_bells ; do(:awesome).stuff ; end
# notes << temple_bells
