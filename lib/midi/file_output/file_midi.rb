class FileMIDI
  attr_accessor :clock, :filename
  def initialize(options)
    raise :hell unless options.is_a? Hash
    @clock = options[:clock]
    @filename = options[:filename]
  end
end
