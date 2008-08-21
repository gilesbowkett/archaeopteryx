require 'lib/archaeopteryx'

@loop.flush if @loop
@loop = Arkx.new(:clock => Clock.new(90),
                 :measures => 4,
                 :logging => false,
                 :evil_timer_offset_wtf => 0.2,
                 :generator => MetacircularEvaluator.new("eval_style.rb"))
@loop.go

# if you move mutation definition into drum file you can alternate between 16-bar long loops
# and 2-bar fills.
