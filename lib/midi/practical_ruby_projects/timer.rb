module Archaeopteryx
  module Midi
    module PracticalRubyProjects
      class Timer
        def initialize(resolution)
          @resolution = resolution
          @queue = []

          Thread.new do
            while true
              dispatch
              sleep(@resolution)
            end
          end
        end
        
        def flush
          @queue = []
        end

        def at(time, &block)
          time = time.to_f if time.kind_of?(Time)
          @queue.push [time, block]
        end

        private
        def dispatch
          now = Time.now.to_f
          ready, @queue = @queue.partition {|time, proc| time <= now}
          ready.each {|time, proc| proc.call(time)}
        end
      end
    end
  end
end
