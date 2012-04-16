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

  def rational_bookmaker?
    sum_inverse_outcome > 1
  end

  def sum_inverse_outcome
    fractions.reduce(0) {|sum, n| sum + 1 / n }
  end

  def bookmakers_return_rate
    fs = fractions
    1 - fs.reduce(:*) / fs.reduce(:+)
  end

  def profit params={}
    s1 = params[:stake]
    o1 = params[:odds]
    r1 = o1.profit_on_winning_stake s1

    s2 = other_amount params
    o2 = other_odds o1
    r2 = o2.profit_on_winning_stake s2

    # FIXME want to allow a penny leeway
    #raise %{getting differing returns of #{r1} and #{r2}} unless r1 == r2
    # FIXME might want to use lowest return here to give worst case result
    r1 - total_stake(stake: s1, odds: o1)
  end

  def other_amount params={}
    # FIXME what happens with duplicate odds?
    # TODO this only works with two outcomes
    s1 = params[:stake]
    o1 = params[:odds]
    o2 = other_odds(o1)

    s1 * o1.fractional_odds / o2.fractional_odds
  end

  def percentages
    hash = {}
    @mutually_exclusive_outcome_odds.each {|odds| hash[odds] = 1 / odds.fractional_odds / sum_inverse_outcome }
    hash
  end

  def bet_amounts_for_total total_stake
    hash = {}
    @mutually_exclusive_outcome_odds.each {|odds| hash[odds] = total_stake * 1 / odds.fractional_odds / sum_inverse_outcome }
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
    # TODO work this out without putting in example stake
    total_stake = Money.from_fixnum(100, :GBP)
    bet_amounts_for_total = bet_amounts_for_total total_stake
    odds = bet_amounts_for_total.keys.first
    winnings = odds.profit_on_winning_stake bet_amounts_for_total[odds]

    winnings / total_stake - 1
  end

  private

    def other_odds odds
      (@mutually_exclusive_outcome_odds - [odds]).first
    end

    def total_stake params={}
      s1 = params[:stake]
      s2 = other_amount stake: s1, odds: params[:odds]
      s1 + s2
    end

    def fractions
      @mutually_exclusive_outcome_odds.collect {|o| o.fractional_odds }
    end
end