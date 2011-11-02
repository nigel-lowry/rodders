require 'money'

class FixedOdds

  attr_reader :fractionalOdds

  def FixedOdds.fractionalOdds fractionalOddsString
    if fractionalOddsString.end_with? ' against'
      return FixedOdds.new(Rational(fractionalOddsString.chomp(' against')))
    end

    if fractionalOddsString.end_with? ' on'
      return FixedOdds.new(Rational(fractionalOddsString.chomp(' on')).reciprocal)
    end

    if fractionalOddsString == 'evens' || fractionalOddsString == 'even money' 
      return FixedOdds.new(Rational('1/1'))
    end

    FixedOdds.new(Rational(fractionalOddsString))
  end

  def FixedOdds.moneylineOdds moneyline
    return FixedOdds.new(Rational("#{moneyline}/100"))
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