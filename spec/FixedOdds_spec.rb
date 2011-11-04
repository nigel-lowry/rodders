require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "FixedOdds" do

  describe "fractional_odds factory" do
    it "should raise error if not fractional odds" do
      expect {
        FixedOdds.fractional_odds '-400'
      }.to raise_error(
        RuntimeError,
        /could not parse "-400" as fractional odds/
      )  
    end

    it "should not modify the input string with 'against'" do
      value = '4/1 against'
      FixedOdds.fractional_odds(value)
      value.end_with?('against').should == true
    end

    it "should not modify the input string with 'on'" do
      value = '4/1 on'
      FixedOdds.fractional_odds(value)
      value.end_with?('on').should == true
    end

    it "should treat '4/1 against' the same as '4/1'" do
      FixedOdds.fractional_odds('4/1 against').should == FixedOdds.fractional_odds('4/1')
    end

    it "should treat '4/1 on' the same as '1/4'" do
      FixedOdds.fractional_odds('4/1 on').should == FixedOdds.fractional_odds('1/4')
    end
    
    it "should treat 'evens' as '1/1'" do 
      FixedOdds.fractional_odds('evens').should == FixedOdds.fractional_odds('1/1')
    end 

    it "should treat 'even money' as '1/1'" do
      FixedOdds.fractional_odds('even money').should == FixedOdds.fractional_odds('1/1')
    end

    it "should recognise '4-to-1' as '4/1'" do
      FixedOdds.fractional_odds('4-to-1').should == FixedOdds.fractional_odds('4/1')
    end

    it "should recognise '4-to-1 against' as '4/1'" do
      FixedOdds.fractional_odds('4-to-1 against').should == FixedOdds.fractional_odds('4/1')
    end

    it "should recognise '4-to-1 on' as '1/4'" do
      FixedOdds.fractional_odds('4-to-1 on').should == FixedOdds.fractional_odds('1/4')
    end
  end

  describe "moneyline_odds factory" do
    it "should raise error if not moneyline odds" do
      expect {
        FixedOdds.moneyline_odds '1.25'
      }.to raise_error(
        RuntimeError,
        /could not parse "1.25" as moneyline odds/
      )  
    end

    describe "positive figures" do
      it "should treat '+400' as meaning winning $400 on a $100 bet" do
        plus400 = FixedOdds.moneyline_odds('+400')
        plus400.stake = '$100'
        plus400.profit.should == '$400'
      end

      it "should treat +100 as meaning winning $100 on a $100 bet" do
        plus100 = FixedOdds.moneyline_odds('+100')
        plus100.stake = '$100'
        plus100.profit.should == '$100'
      end
    end

    describe "negative figures" do
      it "should treat '-400' as meaning you need to wager $400 to win $100" do
        minus400 = FixedOdds.moneyline_odds('-400')
        minus400.stake = '$400'
        minus400.profit.should == '$100'
      end

      it "should treat '-100' as meaning you need to wager $100 to win $100 (which is identical to '+100')" do
        minus100 = FixedOdds.moneyline_odds('-100')
        minus100.stake = '$100'
        minus100.profit.should == '$100'
      end
    end
  end

  describe "decimal_odds factory" do
    it "should raise error if not decimal odds" do
      expect {
        FixedOdds.decimal_odds '-400'
      }.to raise_error(
        RuntimeError,
        /could not parse "-400" as decimal odds/
      )  
    end

    it "should treat '2' as meaning you have to wager $100 to win $100" do
      d2 = FixedOdds.decimal_odds('2')
      d2.stake = '$100'
      d2.profit.should == '$100'
    end

    it "should treat '5' as meaning you have to wager $100 to win $400" do
      d5 = FixedOdds.decimal_odds('5')
      d5.stake = '$100'
      d5.profit.should == '$400'
    end

    it "should treat '1.25' as meaning yo have to wager $400 to win $100" do
      d1_25 = FixedOdds.decimal_odds('1.25')
      d1_25.stake = '$400'
      d1_25.profit.should == '$100'
    end
  end

  describe "#from_s" do
    describe "bad input" do
      it "should reject garbage" do
        expect {
          FixedOdds.from_s('garbage')  
        }.to raise_error(
          ArgumentError,
          /could not parse "garbage"/
        )
      end
    end

    describe "fractional odds" do
      it "should parse '4/1'" do
        FixedOdds.from_s('4/1').should == FixedOdds.fractional_odds('4/1')
      end

      it "should parse 'evens'" do
        FixedOdds.from_s('evens').should == FixedOdds.fractional_odds('1/1')
      end

      it "should parse 'even money'" do
        FixedOdds.from_s('even money').should == FixedOdds.fractional_odds('1/1')
      end

      it "should parse '4/1 against'" do
        FixedOdds.from_s('4/1 against').should == FixedOdds.fractional_odds('4/1')
      end

      it "should parse '4/1 on'" do
        FixedOdds.from_s('4/1 on').should == FixedOdds.fractional_odds('1/4')
      end

      it "should parse '4-to-1'" do
        FixedOdds.from_s('4-to-1').should == FixedOdds.fractional_odds('4/1')
      end

      it "should parse '4-to-1 against'" do
        FixedOdds.from_s('4-to-1 against').should == FixedOdds.fractional_odds('4/1')
      end

      it "should parse '4-to-1 on'" do
        FixedOdds.from_s('4-to-1 on').should == FixedOdds.fractional_odds('1/4')
      end
    end

    describe "moneyline odds" do
      it "should parse positive moneyline odds" do 
        FixedOdds.from_s('+400').should == FixedOdds.moneyline_odds('+400')
      end

      it "should parse negative moneyline odds" do
        FixedOdds.from_s('-400').should == FixedOdds.moneyline_odds('-400')
      end
    end

    describe "decimal odds" do
      it "should parse integral odds" do
        FixedOdds.from_s('2').should == FixedOdds.decimal_odds('2')
      end

      it "should parse floating-point odds" do
        FixedOdds.from_s('1.25').should == FixedOdds.decimal_odds('1.25')
      end
    end
  end

  describe "#==" do
    it "should treat similar fractions equally" do 
      FixedOdds.fractional_odds('100/30').should == FixedOdds.fractional_odds('10/3')
    end

    it "should recognise '1/1' and '2' are the same" do
      FixedOdds.fractional_odds('1/1').should == FixedOdds.decimal_odds('2')
    end

    it "should recognise '4/1' and '5' are the same" do
      FixedOdds.fractional_odds('4/1').should == FixedOdds.decimal_odds('5')
    end

    it "should recognise '1/4' and '1.25' are the same" do
      FixedOdds.fractional_odds('1/4').should == FixedOdds.decimal_odds('1.25')
    end

    it "should recognise '4/1' and '+400' are the same" do
      FixedOdds.fractional_odds('4/1').should == FixedOdds.moneyline_odds('+400')
    end

    it "should recognise '1/4' and '-400' are the same" do
      FixedOdds.fractional_odds('1/4').should == FixedOdds.moneyline_odds('-400')
    end

    it "should recognise '+100' and '-100' are the same" do
      FixedOdds.moneyline_odds('+100').should == FixedOdds.moneyline_odds('-100')
    end
  end

  describe "#to_s" do
    it "should display the odds in fractional odds format" do
      FixedOdds.from_s('+400').to_s.should == '4/1'
    end
  end

  describe "#to_s_fractional" do
    it "should display '4/1' as '4/1'" do
      FixedOdds.fractional_odds('4/1').to_s_fractional.should == '4/1'
    end

    it "should print out '100/30' as '10/3' in lowest terms" do
      FixedOdds.fractional_odds('100/30').to_s_fractional.should == '10/3'
    end

    it "should display '+400' as '4/1'" do
      FixedOdds.moneyline_odds('+400').to_s_fractional.should == '4/1'
    end

    it "should display '5' as '4/1'" do 
      FixedOdds.decimal_odds('5').to_s_fractional.should == '4/1'
    end

    it "should display '+100' as '1/1'" do
      FixedOdds.moneyline_odds('+100').to_s_fractional.should == '1/1'
    end

    it "should display '-100' as '1/1'" do
      FixedOdds.moneyline_odds('-100').to_s_fractional.should == '1/1'
    end
  end

  describe "#to_s_moneyline" do
    it "should display '+400' as '+400'" do
      FixedOdds.moneyline_odds('+400').to_s_moneyline.should == ('+400')
    end

    it "should display '+100' as '-100' (but this could have equally been '+100')" do
      FixedOdds.moneyline_odds('+100').to_s_moneyline.should == ('-100')
    end

    it "should display '-100' as '-100' (but this could have equally been '+100')" do
      FixedOdds.moneyline_odds('-100').to_s_moneyline.should == ('-100')
    end

    it "should display '4/1' as '+400'" do
      FixedOdds.fractional_odds('4/1').to_s_moneyline.should == '+400'
    end

    it "should display '5' as '+400'" do
      FixedOdds.decimal_odds('5').to_s_moneyline.should == '+400'
    end

    it "should display '1.25' as '-400'" do
      FixedOdds.decimal_odds('1.25').to_s_moneyline.should == '-400'
    end

    it "should display a floating point moneyline"
  end

  describe "#to_s_decimal" do
    it "should display '1.25' as '1.25'" do
      FixedOdds.decimal_odds('1.25').to_s_decimal.should == '1.25'
    end

    it "should display '1/4' as '1.25'" do
      FixedOdds.fractional_odds('1/4').to_s_decimal.should == '1.25'
    end

    it "should display '-400' as '1.25'" do
      FixedOdds.moneyline_odds('-400').to_s_decimal.should == '1.25'
    end

    it "should display '+100' as '2'" do
      FixedOdds.moneyline_odds('+100').to_s_decimal.should == '2'
    end

    it "should display '-100' as '2'" do
      FixedOdds.moneyline_odds('-100').to_s_decimal.should == '2'
    end
  end

  describe "#stake" do
    it "should return nil for an uninitialized stake" do
      FixedOdds.from_s('evens').stake.should be_nil
    end

    it "should return the stake set" do
      stakeAmount = '$100'
      odds = FixedOdds.from_s('evens')
      odds.stake = stakeAmount
      odds.stake.should == stakeAmount
    end
  end

  describe "#inReturn" do
    it "should raise an error if stake is uninitialized" do
      expect {
        FixedOdds.from_s('evens').inReturn
      }.to raise_error(
        RuntimeError,
        /stake uninitialized/
      )
    end

    it "should show that the full amount back on a winning 4/1 bet with a $100 stake is $500" do
      fourToOne = FixedOdds.fractional_odds '4/1'
      fourToOne.stake = '$100'
      fourToOne.inReturn.should == '$500'
    end

    it "should show that the full amount back on a winning 1/4 bet with a $100 stake is $125" do
      oneToFour = FixedOdds.fractional_odds '1/4'
      oneToFour.stake = '$100'
      oneToFour.inReturn.should == '$125'
    end
  end

  describe "#profit" do
    it "should raise an error if stake is uninitialized" do
      expect {
        FixedOdds.from_s('evens').profit
      }.to raise_error(
        RuntimeError,
        /stake uninitialized/
      )
    end

    it "should return a profit of $400 on a $100 stake on a 4/1 bet" do 
      fourToOne = FixedOdds.fractional_odds '4/1'
      fourToOne.stake = '$100'
      fourToOne.profit.should == '$400'
    end

    it "should return a profit of $25 on a $110 stake with a 1/4 bet" do
      oneToFour = FixedOdds.fractional_odds '1/4'
      oneToFour.stake = '$100'
      oneToFour.profit.should == '$25'
    end
  end

  describe "object comparison" do
    it "'+915' is less likely than '-275'" do
      FixedOdds.from_s('+915') < FixedOdds.from_s('-275')
    end

    it "'-275' is more likely than '+915'" do
      FixedOdds.from_s('-275') > FixedOdds.from_s('+915')
    end 
  end
end
