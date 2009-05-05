alias :L :lambda

%w{rubygems midilib/sequence midilib/consts}.each {|lib| require lib}

%w{lib/core_ext/struct
   lib/core_ext/array
   
   lib/loop
   lib/drum
   lib/rhythm
   lib/mix
   
   lib/live_hacks
   lib/track
   lib/clip
   
   lib/midi/note
   lib/midi/clock

   lib/midi/file_output/file_midi

   lib/midi/practical_ruby_projects/no_midi_destinations
   lib/midi/practical_ruby_projects/core_midi
   lib/midi/practical_ruby_projects/core_foundation
   lib/midi/practical_ruby_projects/live_midi
   lib/midi/practical_ruby_projects/timer}.each do |lib|
     require File.expand_path(File.dirname(__FILE__)) + "/../#{lib}"
   end

[Archaeopteryx,
 Archaeopteryx::Midi,
 Archaeopteryx::Midi::PracticalRubyProjects].each {|constant| include constant}
