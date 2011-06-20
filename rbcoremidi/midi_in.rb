require File.dirname(__FILE__) + '/coremidi'

class MidiIn
  include CoreMIDI

  def initialize
    # Names are arbitrary
    client = CoreMIDI.create_client("SB")
    @port = CoreMIDI.create_input_port(client, "Port1")
    @port2 = CoreMIDI.create_input_port(client, "Port2")
  end

  def scan
    CoreMIDI.sources.each_with_index do |source, index|
      puts "found device: source #{index}: #{source}"
    end
  end

  def link(source)
    port = rand > 0.5 ? @port : @port2
    connect_source_to_port(source, port) # 0 is index into CoreMIDI.sources array
  end

  def capture
    while true
     if packets = new_data?
       yield parse(packets)
     end
   end
  end
  
  def parse(packets)
    packets.collect do |packet|
      puts "packet #{packet.data.inspect}"
    end
  end
end

