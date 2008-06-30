class InfiniteBeats < InfiniteStream
  attr_accessor :start, :interval
  def generating_loop
    @start ||= 8 # magic numbers could obviously be args
    @interval ||= 8 # magic numbers could obviously be args
    generate(@start)
    car, cdr = @start, (@start + @interval)
    loop do
      generate(cdr)
      car, cdr = cdr, cdr + @interval
    end 
  end 
end
