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

  def sum_inverse_outcome
    decimals.reduce(0) {|sum, n| sum + 1 / n } 
  end

  def rational_bookmaker?
    sum_inverse_outcome > 1
  end

  def bookmakers_return_rate
    1 - decimals.reduce(:*) / decimals.reduce(:+)
  end

  def other_amount params={}
    params[:stake] * decimal(params[:odds]) / decimal(params[:odds_other])
  end

  private
    def decimals
      @events.collect {|event| decimal event }
    end

    def decimal odds
      odds.to_s_decimal.to_f
    end
end