# A collection of mutually exclusive odds for different outcomes.
# TODO duplicate odds
class MutuallyExclusiveCollection
  # create a new collection with the given odds
  # @param [Array<FixedOdds>] mutually_exclusive_outcome_odds the odds for all the mutually exclusive outcomes
  def initialize(mutually_exclusive_outcome_odds)
    @mutually_exclusive_outcome_odds = mutually_exclusive_outcome_odds.sort
  end

  # the least likely of the odds to occur
  # @return [FixedOdds] the least likely odd
  def least_likely
    @mutually_exclusive_outcome_odds.first
  end

  # the most likely of the odds to occur
  # @return [FixedOdds] the most likely odd
  def most_likely
    @mutually_exclusive_outcome_odds.last
  end  

  # the odds in ascending order of probability
  # @return [Array<FixedOdds>] odds in ascending probability
  def in_ascending_probability
    @mutually_exclusive_outcome_odds
  end

  # the odds in descending order of probability
  # @return [Array<FixedOdds>] odds in descending probability
  def in_descending_probability
    @mutually_exclusive_outcome_odds.reverse
  end

  def arbitrageable?
    sum_inverse_outcome < 1
  end

  

  def bookmakers_return_rate
    fs = fractions
    1 - fs.reduce(:*) / fs.reduce(:+)
  end

  def percentages
    hash = {}
    @mutually_exclusive_outcome_odds.each {|odds| hash[odds] = 1 / odds.fractional_odds / sum_inverse_outcome }
    hash
  end

  def bet_amounts_for_total total_stake
    hash = {}
    @mutually_exclusive_outcome_odds.each {|odds| hash[odds] = total_stake / odds.fractional_odds / sum_inverse_outcome }
    hash
  end

  def bet_amounts_for_profit desired_profit
    bet_amounts_for_total(total_stake_for_profit(desired_profit))
  end

  def total_stake_for_profit desired_profit
    desired_profit / profit_percentage
  end

  def profit_from_total_stake total_stake
    total_stake * profit_percentage
  end

  def profit_percentage
    sum = sum_inverse_outcome
    (1 - sum) / sum
  end

  private
    def sum_inverse_outcome
      fractions.reduce(0) {|sum, n| sum + Rational(1, n) }
    end

    def fractions
      @mutually_exclusive_outcome_odds.collect {|o| o.fractional_odds }
    end
end