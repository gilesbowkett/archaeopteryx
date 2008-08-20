module Archaeopteryx
  class MetacircularEvaluator
    def initialize(file)
      @file = file
      reload
    end
    def reload
      eval(File.read(@file))
      puts "hey"
    end
    def notes(beat)
      []
    end
    def mutate(measure)
      reload
    end
  end
end

# This class is not a real metacircular evaluator. This class abuses the looping framework of
# Arx to enable tempo-changing with the minimum of effort. This is totally what people hate on
# Rails programmers for, but fuck 'em.

# After Burning Man I'm going to fix this. For now, the system is this: you set up a big Arx
# with a MetacircularEvaluator periodically reloading a file. That file is a normal, traditional
# Arx file, which sets up an Arx and points it at a drum definition file. (Notice the absurd
# hackery.) So in addition to modifying the drum file live to change the drums the system plays,
# you can also modify the file which invokes that process, to alter the tempo at which it happens.

# Again, I'm only doing it this ridiculous, stupid way because Burning Man is in a few fucking
# days and I promised one person this feature while promising somebody else harmony and melody,
# which I have to code either tonight or tomorrow. It's definitely good that I've given up coffee,
# I'm already running too much adrenaline.

# On a related topic, none of the continuations code does anything, and I totally stopped using
# all the fractals and Fibonacci shit. there's an element of pretentiousness here. I used to
# consider that a feature but now I think of it as a bug and will fix it near-future.
