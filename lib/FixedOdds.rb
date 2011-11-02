require 'money'

class FixedOdds
	attr_accessor :stake

	def initialize fractionalOdds
		@fractionalOdds = fractionalOdds
	end

  def profit
  	/(?<numerator>\d+)\/(?<denominator>\d+)/ =~ @fractionalOdds

  	multiplier = numerator.to_f / denominator.to_f
  	stake * multiplier
  end

  def inReturn
  	profit + stake
  end
  
end