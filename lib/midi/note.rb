module Archaeopteryx
  module Midi
    class Note < Struct.new(:channel, :number, :duration, :velocity)
      def to_code
        "Note.new(#{self.channel}, #{self.number}, #{self.duration}, #{self.velocity})"
      end
    end
  end
end
