alias :L :lambda

%w{lib/core_ext/struct
   lib/core_ext/array
   
   lib/arkx
   lib/drum
   lib/fx
   lib/rhythm
   lib/rhythm_without_eval
   lib/scale_traversal_rhythm
   lib/sequence
   lib/mix
   lib/bassline
   
   lib/pitches
   
   lib/live_hacks
   lib/track
   lib/clip
   
   lib/infinite_stream
   lib/infinite_beats
   lib/feigenbaum
   lib/metacircular_evaluator

   lib/midi/note
   lib/midi/clock

   lib/midi/practical_ruby_projects/no_midi_destinations
   lib/midi/practical_ruby_projects/core_midi
   lib/midi/practical_ruby_projects/core_foundation
   lib/midi/practical_ruby_projects/live_midi
   lib/midi/practical_ruby_projects/timer}.each do |lib|
     require File.join(File.dirname(__FILE__), '../', lib)
   end

[Archaeopteryx,
 Archaeopteryx::Midi,
 Archaeopteryx::Midi::PracticalRubyProjects].each {|constant| include constant}
