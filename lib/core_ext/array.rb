class Array
  def random
    self[rand(self.size)]
  end
end

# the weird thing is, sometimes this method works and sometimes it doesn't. it happens with other
# libs as well as this one. wtf is going on there? gotta investigate that shit.

# oh fuck I think I know why. I require ActiveSupport in my IRB so I'm assuming Array#rand from
# AS is part of Ruby itself. ooops.
