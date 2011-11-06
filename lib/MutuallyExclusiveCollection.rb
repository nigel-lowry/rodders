# A collection of mutually exclusive events.
#--
# The events are not currently enforced as being
# mutually exclusive so are really just plain
# old events right now.
class MutuallyExclusiveCollection
  # create a new collection with the given events
  def initialize(events)
    @events = events.sort
  end

  # the least likely of the events to occur
  def underdog
    @events.first
  end

  # the most likely of the events to occur
  def favorite
    @events.last
  end  

  # the events in ascending order of probability
  def in_ascending_probability
    @events
  end

  # the events in descending order of probability
  def in_descending_probability
    @events.reverse
  end
end