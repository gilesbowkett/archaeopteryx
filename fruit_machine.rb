require 'lib/archaeopteryx'

$clock = Clock.new(170)
$mutation = L{|measure| 0 == (measure - 1) % 2}
$measures = 4

# fruit machine
kick_loop1 = Clip.new(:controller_number => 0)
kick_loop2 = Clip.new(:controller_number => 1)
hit_the_button = Clip.new(:controller_number => 2)
foolish_boy = Clip.new(:controller_number => 3)
running_like_a_steam_train = Clip.new(:controller_number => 4)
ka_ka_kaching_boy = Clip.new(:controller_number => 5)
guitar_ending = Clip.new(:controller_number => 6)
fruit_machine = Track.new(:rhythms => [kick_loop1,
                                       kick_loop2,
                                       hit_the_button,
                                       foolish_boy,
                                       running_like_a_steam_train,
                                       ka_ka_kaching_boy,
                                       guitar_ending])

# system
db_intro = Clip.new(:controller_number => 7)
db_real_kick = Clip.new(:controller_number => 8)
db_hats_pads_bass = Clip.new(:controller_number => 9)
pads_only = Clip.new(:controller_number => 10)
system = Track.new(:rhythms => [db_intro,
                                db_real_kick,
                                db_hats_pads_bass,
                                pads_only])


@loop = Arkx.new(:clock => $clock, # rename Arkx to Loop
                 :measures => $measures,
                 :logging => false,
                 :evil_timer_offset_wtf => 0.2,
                 :generator => Mix.new(:rhythms => [fruit_machine, system]))
@loop.go

# this A) makes the shit stay running til it's ready B) sends stop midi message
if gets
  @loop.midi.clear
  @loop.midi.pulse(0, 11, 127)
end
