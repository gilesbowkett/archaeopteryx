# direct copy, with adaptations, of Generator class by Jim Weirich in Hal Fulton's
# book "The Ruby Way."

class InfiniteStream
  def initialize
    callcc do |context|
      @generator_context = context
      return
    end
    generating_loop
  end
  def next
    callcc do |here|
      @main_context = here
      @generator_context[]
    end
  end
  def generate(value)
    callcc do |context|
      @generator_context = context
      @main_context[value]
    end
  end  
end
