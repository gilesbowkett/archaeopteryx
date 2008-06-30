module Archaeopteryx
  class Drum
    attr_accessor :note, :probabilities, :when, :next, :number_generator
    def initialize(attributes)
      %w{note probabilities when next number_generator}.each do |attribute|
        eval("@#{attribute} = attributes[:#{attribute}]")
      end
      @queue = [attributes[:when]]
      generate
    end
    def play?(beat)
      @when[beat]
    end
    def generate
      beats_on_which_to_play = []
      @probabilities.each_with_index do |probability, index|
        beats_on_which_to_play << index if @number_generator[] <= probability
      end
      @queue << L{|beat| beats_on_which_to_play.include? beat}
      @when = @next[@queue]
    end
    alias :mutate :generate
  end
end
