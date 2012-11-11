require 'money'
require 'active_support/all'

# Represents fixed odds used in gambling and betting. Supports fractional,
# moneyline and decimal representations. Can calculate the profit
# and return on a winning bet.
class FixedOdds
  include Comparable

  # the fractional odds as a Rational
  attr_reader :fractional_odds

  # creates a new FixedOdds from a string which can be in fractional, 
  # moneyline or decimal format
  # @note strings like '5' are parsed as decimal odds, not as being
  # equivalent to '5/1'
  # @param [String] odds the odds in fractional, moneyline or decimal form
  # @return [FixedOdds]
  def FixedOdds.from_s odds
    case
    when fractional_odds?(odds) then fractional_odds odds
    when moneyline_odds?(odds)  then moneyline_odds odds
    when decimal_odds?(odds)    then decimal_odds odds
    else                        raise ArgumentError, %{could not parse "#{odds}"}
    end
  end

  # tells if the odds are in fractional form
  # @param [String] odds the odds representation
  # @return [Boolean] to indicate if it matches
  def FixedOdds.fractional_odds? odds
    odds =~ /^([1-9]\d*(\/|-to-)[1-9]\d*( (against|on))?|evens|even money)$/
  end

  # tells if the odds are in moneyline form
  # @param (see FixedOdds.fractional_odds?)
  # @return (see FixedOdds.fractional_odds?)
  def FixedOdds.moneyline_odds? odds
    odds =~ /^[+-][1-9]\d*$/ 
  end

  # tells if the odds are in decimal form
  # @param (see FixedOdds.fractional_odds?)
  # @return (see FixedOdds.fractional_odds?)
  def FixedOdds.decimal_odds? odds
    odds =~ /^([1-9]\d*(\.\d+)?|\.\d+)$/ 
  end

  # creates a new FixedOdds from fractional form. These can be in the form
  # * 4-to-1
  # * 4-to-1 against
  # * 4-to-1 on
  # * 4/1
  # * 4/1 against
  # * 4/1 on
  # * evens
  # * even money
  # @param [String] fractional odds in fractional form
  # @return (see FixedOdds.from_s)
  def FixedOdds.fractional_odds fractional
    raise %{could not parse "#{fractional}" as fractional odds} unless self.fractional_odds?(fractional)
    return new(1.to_r) if fractional.inquiry.evens? or fractional == 'even money' 

    o = /(?<numerator>\d+)(\/|-to-)(?<denominator>\d+)/.match fractional
    r = Rational o[:numerator], o[:denominator]
    r = r.reciprocal if fractional.end_with? ' on'
    new r
  end

  # creates a new FixedOdds from a Rational
  # @param [Rational] fractional_odds the odds
  def initialize fractional_odds
    @fractional_odds = fractional_odds
  end

  # creates a new FixedOdds from moneyline form. Examples are
  # * +400
  # * -500
  # @note (see #from_s)
  # @param [String] moneyline odds in moneyline form
  # @return (see FixedOdds.from_s)
  def FixedOdds.moneyline_odds moneyline
    raise %{could not parse "#{moneyline}" as moneyline odds} unless self.moneyline_odds?(moneyline)
    sign = moneyline[0]

    case sign
    when '+'
      new(Rational(moneyline, 100))
    else
      new(Rational(100, -moneyline.to_i))
    end
  end

  # creates a new FixedOdds from decimal form. Examples are
  # * 1.25
  # * 2
  # @param [String] decimal odds in decimal form
  # @return (see FixedOdds.from_s)
  def FixedOdds.decimal_odds decimal
    raise %{could not parse "#{decimal}" as decimal odds} unless self.decimal_odds?(decimal)
    new(decimal.to_r - 1)
  end

  # calculates the profit on a winning stake
  # @param [Money] stake the stake
  # @return [Money] the profit
  def profit_on_stake stake
    stake * @fractional_odds
  end

  # calculates the total return on a winning stake
  # (the profit plus the stake)
  # @param (see #profit_on_stake)
  # @return [Money] the total returned
  def total_return_on_stake stake
    profit_on_stake(stake) + stake
  end

  # calculates the stake needed to
  # win the specified amount in profit
  # @param [Money] profit the desired profit
  # @return [Money] the stake required to realise that profit on a winning bet
  def stake_to_profit profit
    profit / @fractional_odds
  end

  # string representation in fractional form like '4/1'
  # @return [String] fractional form representation
  def to_s
    to_s_fractional
  end

  # string representation in fractional form like '4/1'
  # @return (see #to_s)
  def to_s_fractional
    @fractional_odds.to_s
  end

  # string representation in moneyline form (note 
  # there can be some loss of precision to make 
  # the number into an integer)
  # @return [String] moneyline form representation
  def to_s_moneyline
    number = @fractional_odds > 1 ? fractional_odds * 100 : -100 / fractional_odds
    '%+d' % number.round
  end

  # string representation in decimal form
  # @return [String] decimal form representation
  def to_s_decimal
    '%g' % (fractional_odds + 1)
  end

  protected

    # equality method
    def == other
      other.fractional_odds == @fractional_odds
    end

    # low odds are those which pay out the most money
    # on a winning bet and vice-versa
    def <=> other
      other.fractional_odds <=> @fractional_odds
    end
end

class Rational
  # calculates the reciprocal
  # @example
  #   Rational(2/3).reciprocal #=> Rational(3/2)
  # @return [Rational] the reciprocal
  def reciprocal
    1 / self
  end
end