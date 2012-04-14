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
    ds = decimals
    1 - ds.reduce(:*) / ds.reduce(:+)
  end

  def other_amount params={}
    # FIXME what happens with duplicate odds?
    # TODO this only works with two outcomes
    s1 = params[:stake]
    o1 = params[:odds]
    o2 = other_odds(o1)

    s1 * o1.to_f / o2.to_f
  end

  def profit params={}
    s1 = params[:stake]
    o1 = params[:odds]
    r1 = s1 * o1.to_f

    s2 = other_amount params
    o2 = other_odds o1
    r2 = s2 * o2.to_f

    # FIXME want to allow a penny leeway
    #raise %{getting differing returns of #{r1} and #{r2}} unless r1 == r2
    # FIXME might want to use lowest return here to give worst case result
    r1 - invested(stake: s1, odds: o1)
  end

  def profit_percentage
    example_stake = Money.from_fixnum(2, :GBP)
    example_odds = @mutually_exclusive_outcome_odds.first

    collected = example_odds.total_return_on_winning_stake example_stake
    invested = invested(stake: example_stake, odds: @mutually_exclusive_outcome_odds.first)
    collected / invested - 1
  end

  private

    def other_odds odds
      (@mutually_exclusive_outcome_odds - [odds]).first
    end

    def invested params={}
      params[:stake] + other_amount(stake: params[:stake], odds: params[:odds])
    end

    def decimals
      @mutually_exclusive_outcome_odds.collect {|o| o.to_f }
    end
end