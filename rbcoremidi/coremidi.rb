require File.dirname(__FILE__) + '/rbcoremidi.bundle'

module CoreMIDI
  module API
    MidiPacket = Struct.new(:timestamp, :data)
  end
  
  # Returns an instance of MIDIClient
  def self.create_client(name)
    raise "name must be a String!" unless name.class == String
    
    API.create_client(name)
  end
  
  # Returns an instance of InputPort
  def self.create_input_port(client, port_name)
    API.create_input_port(client, port_name)
  end
  
  def new_data?
    data = API.check_for_new_data
    
    return nil if !data || data.empty?
    data
  end

  def self.sources
    API.get_sources
  end

  def self.number_of_sources
    API.get_num_sources
  end
  
  def connect_source_to_port(source, port)
    API.connect_source_to_port(source, port)
  end
  
  def disconnect_source_from_port(source, port)
    API.disconnect_source_from_port(source, port)
  end
end
