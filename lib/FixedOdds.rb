require 'money'

class FixedOdds
  include Comparable

  attr_reader :fractional_odds

  def FixedOdds.from_s odds
    case
    when FixedOdds.fractional_odds?(odds) then FixedOdds.fractional_odds odds
    when FixedOdds.moneyline_odds?(odds)  then FixedOdds.moneyline_odds odds
    when FixedOdds.decimal_odds?(odds)    then FixedOdds.decimal_odds odds
    else                                  raise ArgumentError, %{could not parse "#{odds}"}
    end
  end

  def FixedOdds.fractional_odds? odds
    odds =~ /\d+\/\d+|evens|even money|\d+-to-\d+/
  end

  def FixedOdds.moneyline_odds? odds
    odds =~ /[+-]\d+/ 
  end

  def FixedOdds.decimal_odds? odds
    odds =~ /^(\d+|\d+\.\d+|\.\d+)/ 
  end

  def FixedOdds.fractional_odds fractional
    raise %{could not parse "#{fractional}" as fractional odds} unless FixedOdds.fractional_odds?(fractional)

    if fractional.end_with? ' against'
      return FixedOdds.new(Rational(fractional.chomp(' against')))
    end

    if fractional.end_with? ' on'
      return FixedOdds.new(Rational(fractional.chomp(' on')).reciprocal)
    end

    if fractional == 'evens' || fractional == 'even money' 
      return FixedOdds.new(Rational('1/1'))
    end

    if /(?<numerator>\d+)-to-(?<denominator>\d+)/ =~ fractional
      return FixedOdds.new(Rational("#{numerator}/#{denominator}"))
    end

    FixedOdds.new(Rational(fractional))
  end

  def initialize fractional_odds
    @fractional_odds = fractional_odds
  end

  def FixedOdds.moneyline_odds moneyline
    raise %{could not parse "#{moneyline}" as moneyline odds} unless FixedOdds.moneyline_odds?(moneyline)

    sign = moneyline[0]

    if sign == '+'
      return FixedOdds.new(Rational("#{moneyline}/100"))
    else
      return FixedOdds.new(Rational("100/#{moneyline.to_i.magnitude}"))
    end
  end

  def FixedOdds.decimal_odds decimal
    raise %{could not parse "#{decimal}" as decimal odds} unless FixedOdds.decimal_odds?(decimal)

    d = decimal.to_f

    FixedOdds.new(Rational(d - 1))
  end

  def stake=(value)
    @stake = value.to_money
  end

  def stake
    @stake
  end

  def profit
    raise 'stake uninitialized' if stake.nil?
    stake * @fractional_odds
  end

  def inReturn
    raise 'stake uninitialized' if stake.nil?
    profit + stake
  end

  def to_s
    to_s_fractional
  end

  def to_s_fractional
    @fractional_odds.to_s
  end

  def to_s_moneyline
    integral_number_with_sign_regex = "%+d"

    if @fractional_odds > 1.0
      integral_number_with_sign_regex % (fractional_odds * 100).to_i
    else
      integral_number_with_sign_regex % (-100.0 / fractional_odds)
    end
  end

  def to_s_decimal
    "%g" % (fractional_odds + 1)
  end

  def ==(other)
    other.fractional_odds == @fractional_odds
  end

  def <=>(other)
    @fractional_odds <=> other.fractional_odds
  end
end
