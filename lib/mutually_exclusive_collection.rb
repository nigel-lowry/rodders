# A collection of mutually exclusive odds for different outcomes.
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
    # FIXME what happens with duplicate odds?
    # TODO this only works with two outcomes
    odds_other = (@mutually_exclusive_outcome_odds - [params[:odds]]).first
    params[:stake] * decimal(params[:odds]) / decimal(odds_other)
  end

  private
    def decimals
      @mutually_exclusive_outcome_odds.collect {|o| decimal o }
    end

    def decimal odds
      odds.to_s_decimal.to_f
    end
end