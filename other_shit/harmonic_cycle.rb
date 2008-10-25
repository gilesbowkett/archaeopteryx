$clock.bpm = 30
$mutation = L{|measure| 0 == (measure - 1) % 2}
$measures = 4

@root = OCTAVES[2].to_a[SCALE[[CIRCLE_OF_FIFTHS,CIRCLE_OF_FOURTHS][rand(2)].next]]

def midi_note(midi_note_number, channel, duration)
  Note.create(:channel => channel,
              :number => midi_note_number,
              :duration => duration,
              :velocity => 100 + rand(27))
end

notes = []
bass = Drum.new(:note => midi_note(@root - 36, 1, 3.00),
                :when => L{|beat| false},
                :next => L{|queue| queue[queue.size - 1]},
                :number_generator => L{rand},
                :probabilities => [1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0])
notes << bass
bass5th = Drum.new(:note => midi_note((@root - 36) + 5, 1, 3.00),
                   :when => L{|beat| false},
                   :next => L{|queue| queue[queue.size - 1]},
                   :number_generator => L{rand},
                   :probabilities => [0.0, 0.0, 0.0, 0.0, 0.15, 0.0, 0.0, 0.0, 0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.15, 0.0])
notes << bass5th

# channel 9 is the easter egg!
pad_channel = [2,2,2,2,2,2,2,2,
               7,7,7,7,7,7,7,7,7,
               8,8,8,8,8,8,8,8,
               9,
               10,10,10,10,10,10,10,
               11,11,11,11,11,11,11,11][rand(41)] # 11 is unassigned - sometimes it's silent
# pad_channel = 8
MAJOR_TRIAD.each do |number|
  notes << Drum.new(:note => midi_note(@root + number, pad_channel, 3.00),
                    :when => L{|beat| false},
                    :next => L{|queue| queue[queue.size - 1]},
                    :number_generator => L{rand},
                    :probabilities => [1.0] + [0.0] * 15)
end

def temple_bells
  boost = {}
  # (0..11).each {|note| boost[note] = 0.0}
  # MAJOR_SCALE.each {|note| boost[note] += 0.05}
  # root = MAJOR_SCALE[0] ; boost[root] += 0.2
  MAJOR_TRIAD.each {|note| boost[note] = 0.1}
  
  rhythm = [0.0, 0.0, 0.5, 0.0,
            0.25, 0.0, 0.0, 0.0,
            0.25, 0.0, 0.75, 0.0,
            0.0, 0.05, 0.0, 0.05]
  
  bells = {}
  boost.keys.each do |note|
    bells[note] = rhythm.collect {|probability| probability + boost[note]}
  end
  
  elevated_root = 60 + @root
  wtf = []
  bells.each do |note, probabilities|
    next unless rand > 0.7
    wtf << Drum.new(:note => midi_note(elevated_root + note, 6, 0.25),
                      :when => L{|beat| false},
                      :next => L{|queue| queue[queue.size - 1]},
                      :number_generator => L{rand},
                      :probabilities => probabilities)
  end
  wtf.compact
  wtf
end

notes += temple_bells









# this file expected to return array of notes!
notes
