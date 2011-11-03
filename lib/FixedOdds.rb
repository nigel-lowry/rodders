require 'money'

class FixedOdds
  include Comparable

  attr_reader :fractionalOdds

  def FixedOdds.from_s odds
    case
    when FixedOdds.fractional_odds?(odds) then FixedOdds.fractionalOdds odds
    when FixedOdds.moneyline_odds?(odds)  then FixedOdds.moneylineOdds odds
    when FixedOdds.decimal_odds?(odds)    then FixedOdds.decimalOdds odds
    else                                  raise ArgumentError, %{could not parse "#{odds}"}
    end
  end

  def FixedOdds.fractional_odds? odds
    odds =~ /\d+\/\d+|evens|even money/
  end

  def FixedOdds.moneyline_odds? odds
    odds =~ /[+-]\d+/ 
  end

  def FixedOdds.decimal_odds? odds
    odds =~ /(\d+|\d+\.\d+|\.\d+)/ 
  end

  def FixedOdds.fractionalOdds fractional
    if fractional.end_with? ' against'
      return FixedOdds.new(Rational(fractional.chomp(' against')))
    end

    if fractional.end_with? ' on'
      return FixedOdds.new(Rational(fractional.chomp(' on')).reciprocal)
    end

    if fractional == 'evens' || fractional == 'even money' 
      return FixedOdds.new(Rational('1/1'))
    end

    FixedOdds.new(Rational(fractional))
  end

  def initialize fractionalOdds
    @fractionalOdds = fractionalOdds
  end

  def FixedOdds.moneylineOdds moneyline
    sign = moneyline[0]

    if sign == '+'
      return FixedOdds.new(Rational("#{moneyline}/100"))
    else
      return FixedOdds.new(Rational("100/#{moneyline.to_i.magnitude}"))
    end
  end

  def FixedOdds.decimalOdds decimal
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
    stake * @fractionalOdds
  end

  def inReturn
    raise 'stake uninitialized' if stake.nil?
    profit + stake
  end

  def to_s
    to_s_fractional
  end

  def to_s_fractional
    @fractionalOdds.to_s
  end

  def to_s_moneyline
    integral_number_with_sign_regex = "%+d"

    if @fractionalOdds > 1.0
      integral_number_with_sign_regex % (fractionalOdds * 100).to_i
    else
      integral_number_with_sign_regex % (-100.0 / fractionalOdds)
    end
  end

  def to_s_decimal
    "%g" % (fractionalOdds + 1)
  end

  def ==(other)
    other.fractionalOdds == @fractionalOdds
  end

  def <=>(other)
    @fractionalOdds <=> other.fractionalOdds
  end
end
