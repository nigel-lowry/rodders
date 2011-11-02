require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "FixedOdds" do

	before(:each) do
  	@fourToOne = FixedOdds.new "4/1"
	end

	describe "#new" do
		it "should take one argument and return a FixedOdds object"
	end

	describe "#stake" do
		it "should return nil for an uninitialised stake" do
			@fourToOne.stake.should be_nil
		end

		it "should return the stake set" do
			# using the .to_money method in this class is leeking use of the money gem to the API
			stakeAmount = '$100'.to_money
			@fourToOne.stake = stakeAmount
			@fourToOne.stake.should == stakeAmount
		end
	end

	describe "#inReturn" do
		it "should return nil if stake is uninitialised"

		it "should show that the full amount back on a winning 4/1 bet with a $100 stake is $500" do
			@fourToOne.stake = '$100'.to_money
			@fourToOne.inReturn.should == '$500'.to_money
		end
	end

	describe "#profit" do
		it "should return nil for an uninitialised stake"

		it "should return a profit of $400 on a $100 stake on a 4/1 bet" do 
			@fourToOne.stake = '$100'.to_money
			@fourToOne.profit.should == '$400'.to_money
		end
	end
end
