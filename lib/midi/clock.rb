# get singleton from std lib
module Archaeopteryx
  module Midi
    class Clock # < Singleton
      attr_accessor :time, :interval, :start
      def initialize(bpm, beats_in_a_measure = 4.0)
        @start = Time.now.to_f
        @time = 0
        @beats_in_a_measure = beats_in_a_measure
        self.bpm = bpm
      end
      def bpm=(bpm)
        seconds_in_a_minute = 60.0
        @interval = seconds_in_a_minute / bpm.to_f / @beats_in_a_measure
      end
      def tick
        @time += @interval
      end
    end
  end
end
