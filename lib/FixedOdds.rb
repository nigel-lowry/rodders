require 'money'

class FixedOdds

	def initialize fractionalOdds
		@fractionalOdds = fractionalOdds
	end

	def stake=(value)
		@stake = value.to_money
	end

	def stake
		@stake
	end

  def profit
  	/(?<numerator>\d+)\/(?<denominator>\d+)/ =~ @fractionalOdds

  	multiplier = numerator.to_f / denominator.to_f
  	stake * multiplier
  end

  def inReturn
  	profit + stake
  end

  def to_s
  	@fractionalOdds
  end
  
end