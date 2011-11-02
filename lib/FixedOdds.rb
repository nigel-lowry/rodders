require 'money'

class FixedOdds

  attr_reader :fractionalOdds

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

  def FixedOdds.moneylineOdds moneyline
    sign = moneyline[0]

    if sign == '+'
      return FixedOdds.new(Rational("#{moneyline}/100"))
    else
      return FixedOdds.new(Rational("100/#{moneyline.to_i.abs}"))
    end
  end

  def FixedOdds.decimalOdds decimal
    d = decimal.to_f

    FixedOdds.new(Rational(d -= 1))
  end

  def stake=(value)
    @stake = value.to_money
  end

  def stake
    @stake
  end

  def profit
    stake * @fractionalOdds
  end

  def inReturn
    profit + stake
  end

  def to_s
    @fractionalOdds.to_s
  end

  def ==(other)
    other.fractionalOdds == @fractionalOdds
  end

  private

    def initialize fractionalOdds
      @fractionalOdds = fractionalOdds
    end
  
end