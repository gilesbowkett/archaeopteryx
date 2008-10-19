class Message < Struct.new(:midi_channel, :controller_number, :value)
end

class TapTempo
  def midi_channel; 15 ; end
  def controller_number ; 7 ; end
  def value ; 127 ; end
end
