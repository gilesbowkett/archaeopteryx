# get singleton from std lib
module Archaeopteryx
  module Midi
    class Clock # < Singleton
      attr_reader :time, :interval, :start
      def initialize(bpm)
       # assumes 16-step step sequencer, 4/4 beat, etc.
        self.bpm = bpm
        @start = Time.now.to_f
        @time = 0
      end
      def bpm=(bpm)
        seconds_in_a_minute = 60.0
        beats_in_a_measure = 4.0
        @interval = seconds_in_a_minute / bpm.to_f / beats_in_a_measure
      end
      def tick
        @time += @interval
        @time
      end
    end
  end
end
