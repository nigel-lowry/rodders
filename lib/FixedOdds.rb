require 'money'

class FixedOdds

	attr_reader :fractionalOdds

	def initialize fractionalOdds
    if fractionalOdds.end_with? ' against'
    	fractionalOdds.chomp! ' against'
    end

    if fractionalOdds.end_with? ' on'
    	fractionalOdds.chomp! ' on'

    	/(?<numerator>\d+)\/(?<denominator>\d+)/ =~ fractionalOdds

    	fractionalOdds = "#{denominator}/#{numerator}"
    end

		if fractionalOdds == 'evens' || fractionalOdds == 'even money' 
			@fractionalOdds = '1/1'
		else
			@fractionalOdds = fractionalOdds
		end
	end

	def stake=(value)
		@stake = value.to_money
	end

	def stake
		@stake
	end

  def profit
  	stake * Rational(@fractionalOdds)
  end

  def inReturn
  	profit + stake
  end

  def to_s
  	@fractionalOdds
  end

  def ==(other)
  	other.fractionalOdds == @fractionalOdds
  end
  
end