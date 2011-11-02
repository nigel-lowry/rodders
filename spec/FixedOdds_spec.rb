require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "FixedOdds" do

  before(:each) do
    @fourToOne = FixedOdds.fractionalOdds '4/1'
    @oneToFour = FixedOdds.fractionalOdds '1/4'
  end

  describe "fractionalOdds factory" do
    it "should take one argument and return a FixedOdds object"

    it "should not modify the input string with 'against'" do
      value = '4/1 against'
      FixedOdds.fractionalOdds(value)
      value.end_with?('against').should == true
    end

    it "should not modify the input string with 'on'" do
      value = '4/1 on'
      FixedOdds.fractionalOdds(value)
      value.end_with?('on').should == true
    end

    it "should treat '4/1 against' the same as '4/1'" do
      FixedOdds.fractionalOdds('4/1 against').should == FixedOdds.fractionalOdds('4/1')
    end

    it "should treat '4/1 on' the same as '1/4'" do
      FixedOdds.fractionalOdds('4/1 on').should == FixedOdds.fractionalOdds('1/4')
    end
    
    it "should treat 'evens' as '1/1'" do 
      FixedOdds.fractionalOdds('evens').should == FixedOdds.fractionalOdds('1/1')
    end 

    it "should treat 'even money' as '1/1'" do
      FixedOdds.fractionalOdds('even money').should == FixedOdds.fractionalOdds('1/1')
    end 
  end

  describe "moneylineOdds factory" do
    describe "positive figures" do
      it "should treat '+400' as meaning winning $400 on a $100 bet" do
        plus400 = FixedOdds.moneylineOdds('+400')
        plus400.stake = '$100'
        plus400.profit.should == '$400'
      end
    end

    describe "negative figures" do
      it "should treat '-400' as meaning you need to wager $400 to win $100" do
        minus400 = FixedOdds.moneylineOdds('-400')
        minus400.stake = '$400'
        minus400.profit.should == '$100'
      end
    end
  end

  describe "#== should treat different multiples of fractional odds equally" do
    it "should treat '100/30' and '10/3' equally" do 
      FixedOdds.fractionalOdds('100/30').should == FixedOdds.fractionalOdds('10/3')
    end
  end

  describe "#to_s" do
    it "should display the odds in fractional odds format" do
      @fourToOne.to_s.should == '4/1'
    end

    it "should print out '100/30' as '10/3'" do
      FixedOdds.fractionalOdds('100/30').to_s.should == '10/3'
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
