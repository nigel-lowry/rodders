require 'money'

class FixedOdds

	attr_reader :fractionalOdds

	def initialize fractionalOdds
    if fractionalOdds.end_with? ' against'
    	@fractionalOdds = Rational(fractionalOdds.chomp(' against'))
    	return
    end

    if fractionalOdds.end_with? ' on'
    	@fractionalOdds = Rational(fractionalOdds.chomp(' on')).reciprocal
    	return
    end

		if fractionalOdds == 'evens' || fractionalOdds == 'even money' 
			@fractionalOdds = Rational('1/1')
			return
		end

		@fractionalOdds = Rational(fractionalOdds)
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
  
end