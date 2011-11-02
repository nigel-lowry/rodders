require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "FixedOdds" do

	before(:each) do
  	@fourToOne = FixedOdds.new "4/1"
  	@oneToFour = FixedOdds.new "1/4"
	end

	describe "#new" do
		it "should take one argument and return a FixedOdds object"
		it "should treat '4/1 against' the same as '4/1'" do
			FixedOdds.new('4/1 against').should == FixedOdds.new('4/1')
		end

		it "should treat '4/1 on' the same as '1/4'" do
			FixedOdds.new('4/1 on').should == FixedOdds.new('1/4')
		end
		
		it "should treat 'evens' as '1/1'" do 
			FixedOdds.new('evens').should == FixedOdds.new('1/1')
		end	

		it "should treat 'even money' as '1/1'" do
			FixedOdds.new('even money').should == FixedOdds.new('1/1')
		end	
	end

	describe "#== should treat different multiples equally" do
		it "should treat '100/30' and '10/3' equally" do 
			FixedOdds.new('100/30').should == FixedOdds.new('10/3')
		end
	end

	describe "#to_s" do
		it "should display the odds in fractional odds format" do
			@fourToOne.to_s.should == '4/1'
		end

		it "should print out '100/30' as '10/3'" do
			FixedOdds.new('100/30').to_s.should == '10/3'
		end
	end

	describe "#stake" do
		it "should return nil for an uninitialised stake" do
			@fourToOne.stake.should be_nil
		end

		it "should return the stake set" do
			stakeAmount = '$100'
			@fourToOne.stake = stakeAmount
			@fourToOne.stake.should == stakeAmount
		end
	end

	describe "#inReturn" do
		it "should return nil if stake is uninitialised"

		it "should show that the full amount back on a winning 4/1 bet with a $100 stake is $500" do
			@fourToOne.stake = '$100'
			@fourToOne.inReturn.should == '$500'
		end

		it "should show that the full amount back on a winning 1/4 bet with a $100 stake is $125" do
			@oneToFour.stake = '$100'
			@oneToFour.inReturn.should == '$125'
		end
	end

	describe "#profit" do
		it "should return nil for an uninitialised stake"

		it "should return a profit of $400 on a $100 stake on a 4/1 bet" do 
			@fourToOne.stake = '$100'
			@fourToOne.profit.should == '$400'
		end

		it "should return a profit of $25 on a $110 stake with a 1/4 bet" do
			@oneToFour.stake = '$100'
			@oneToFour.profit.should == '$25'
		end
	end
end
