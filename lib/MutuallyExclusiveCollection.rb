class MutuallyExclusiveCollection
  def initialize(events)
    @events = events.sort
  end

  def underdog
    @events.first
  end

  def favorite
    @events.last
  end  

  def in_ascending_probability
    @events
  end

  def in_descending_probability
    @events.reverse
  end
end