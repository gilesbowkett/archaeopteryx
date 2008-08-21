# not talking about the queens, but what? the pitches

# parts stolen from jvoorhis music.rb, idea partly original, partly jvoorhis-stolen also

SCALE = {"C" => 0,
           "C#" => 1,
         "D" => 2,
           "D#" => 3,
         "E" => 4,
         "F" => 5,
           "F#" => 6,
         "G" => 7,
           "G#" => 8,
         "A" => 9,
           "A#" => 10,
         "B" => 11} # assuming C major! this isn't quite right. we're not really representing notes here
                    # but positions in the scale.

OCTAVES = {-1 => (0..11), # starting note is C-1
            0 => (12..23),
            1 => (24..35),
            2 => (36..47),
            3 => (48..59),
            4 => (60..71),
            5 => (72..83),
            6 => (84..95),
            7 => (96..107),
            8 => (108..119),
            9 => (120..127)} # the 9th octave is incomplete and only goes as far as G

# chords! this can also happen with scales!
MINOR_7TH = [0, 2, 6, 9]
MAJOR_7TH = [0, 4, 7, 11]
MAJOR_TRIAD = [0,4,7]

MAJOR_SCALE = [0, 2, 4, 5, 7, 9, 11]
MINOR_SCALE = [0, 2, 3, 5, 7, 8, 10]
# higher-resolution nomenclature exists but I won't have time to use it

CIRCLE_OF_FIFTHS = %w{C G D A E B F# C# G# D# A# F}
# relative minor is always x + 3
# this data structure is of course a ring
CIRCLE_OF_FOURTHS = CIRCLE_OF_FIFTHS.reverse

# [CIRCLE_OF_FIFTHS, CIRCLE_OF_FOURTHS].each do |array|
#   class << array
#     def next
#       @current ||= -1
#       @current += 1
#       @current = 0 if @current >= size
#       self[@current]
#     end
#   end
# end
# this makes them into ring structures. I may need to do this for all these arrays.

class Array
  def next
    @current ||= -1
    @current += 1
    @current = 0 if @current >= size
    self[@current]
  end
end
