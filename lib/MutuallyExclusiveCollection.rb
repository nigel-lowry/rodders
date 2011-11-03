class MutuallyExclusiveCollection

  def initialize events
    @events = events.sort
  end

  def underdog
    @events.last
  end

  def favorite
    @events.first
  end  
  
end