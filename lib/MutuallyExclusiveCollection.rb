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

  def in_ascending_probability
    @events.reverse
  end

  def in_descending_probability
    @events
  end
end