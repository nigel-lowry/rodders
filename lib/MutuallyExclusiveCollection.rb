# A collection of mutually exclusive events.
class MutuallyExclusiveCollection
  # create a new collection with the given events
  # @param [Array<FixedOdds>] events the events
  def initialize(events)
    @events = events.sort
  end

  # the least likely of the events to occur
  # @return [FixedOdds] the least likely event
  def least_likely
    @events.first
  end

  # the most likely of the events to occur
  # @return [FixedOdds] the most likely event
  def most_likely
    @events.last
  end  

  # the events in ascending order of probability
  # @return [Array<FixedOdds>] events in ascending probability
  def in_ascending_probability
    @events
  end

  # the events in descending order of probability
  # @return [Array<FixedOdds>] events in descending probability
  def in_descending_probability
    @events.reverse
  end
end