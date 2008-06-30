class Feigenbaum < InfiniteStream
  attr_accessor :robustness
  def generating_loop
    @robustness ||= 3.2
    generate(0.1)
    car = 0.1
    cdr = (@robustness * car * (1 - car))
    loop do
      generate(cdr)
      car, cdr = cdr, (@robustness * cdr * (1 - cdr))
    end
  end
end
