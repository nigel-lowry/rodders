# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "FixedOdds" do

  describe ".fractional_odds" do
    it "raises error if not fractional odds" do
      expect {
        FixedOdds.fractional_odds '5'
      }.to raise_error(
        RuntimeError,
        /could not parse "5" as fractional odds/
      )  
    end

    it "does not change the input string with 'against'" do
      value = '4/1 against'
      FixedOdds.fractional_odds(value)
      value.end_with?('against').should == true
    end

    it "does not modify the input string with 'on'" do
      value = '4/1 on'
      FixedOdds.fractional_odds(value)
      value.end_with?('on').should == true
    end

    it "treats '4/1 against' the same as '4/1'" do
      FixedOdds.fractional_odds('4/1 against').should == FixedOdds.fractional_odds('4/1')
    end

    it "treats '4/1 on' the same as '1/4'" do
      FixedOdds.fractional_odds('4/1 on').should == FixedOdds.fractional_odds('1/4')
    end
    
    it "treats 'evens' as '1/1'" do 
      FixedOdds.fractional_odds('evens').should == FixedOdds.fractional_odds('1/1')
    end 

    it "treats 'even money' as '1/1'" do
      FixedOdds.fractional_odds('even money').should == FixedOdds.fractional_odds('1/1')
    end

    it "treats '4-to-1' as '4/1'" do
      FixedOdds.fractional_odds('4-to-1').should == FixedOdds.fractional_odds('4/1')
    end

    it "treats '4-to-1 against' as '4/1'" do
      FixedOdds.fractional_odds('4-to-1 against').should == FixedOdds.fractional_odds('4/1')
    end

    it "treats '4-to-1 on' as '1/4'" do
      FixedOdds.fractional_odds('4-to-1 on').should == FixedOdds.fractional_odds('1/4')
    end

    it "raises error if numerator has decimal point" do
      expect {
        FixedOdds.fractional_odds '1.1/4'
      }.to raise_error(
        RuntimeError,
        /could not parse "1.1\/4" as fractional odds/
      ) 
    end

    it "raises error if denominator has decimal point" do
      expect {
        FixedOdds.fractional_odds '1/4.1'
      }.to raise_error(
        RuntimeError,
        /could not parse "1\/4.1" as fractional odds/
      ) 
    end

    it "raises error if both numerator and denominator have decimal points" do
      expect {
        FixedOdds.fractional_odds '1.1/4.1'
      }.to raise_error(
        RuntimeError,
        /could not parse "1.1\/4.1" as fractional odds/
      ) 
    end
  end

  describe ".moneyline_odds" do
    it "raises error if not moneyline odds" do
      expect {
        FixedOdds.moneyline_odds '1/4'
      }.to raise_error(
        RuntimeError,
        /could not parse "1\/4" as moneyline odds/
      )  
    end

    it "raises error if moneyline odds has decimal point" do
      expect {
        FixedOdds.moneyline_odds '-100.1'
      }.to raise_error(
        RuntimeError,
        /could not parse "-100.1" as moneyline odds/
      )  
    end

    describe "positive figures" do
      it "treats '+400' as meaning winning £400 on a £100 bet" do
        plus400 = FixedOdds.moneyline_odds('+400')
        plus400.profit_on_stake(Money.parse '£100').should == Money.parse('£400')
      end

      it "treats +100 as meaning winning £100 on a £100 bet" do
        plus100 = FixedOdds.moneyline_odds('+100')
        plus100.profit_on_stake(Money.parse '£100').should == Money.parse('£100')
      end
    end

    describe "negative figures" do
      it "treats '-400' as meaning you need to wager £400 to win £100" do
        minus400 = FixedOdds.moneyline_odds('-400')
        minus400.profit_on_stake(Money.parse '£400').should == Money.parse('£100')
      end

      it "treats '-100' as meaning you need to wager £100 to win £100" do
        minus100 = FixedOdds.moneyline_odds('-100')
        minus100.profit_on_stake(Money.parse '£100').should == Money.parse('£100')
      end

      it "treats '+100' as meaning you need to wager £100 to win £100" do
        plus100 = FixedOdds.moneyline_odds('+100')
        plus100.profit_on_stake(Money.parse '£100').should == Money.parse('£100')
      end
    end
  end

  describe ".decimal_odds" do
    it "raises error if not decimal odds" do
      expect {
        FixedOdds.decimal_odds '-400'
      }.to raise_error(
        RuntimeError,
        /could not parse "-400" as decimal odds/
      )  
    end

    it "treats '2' as meaning you have to wager £1 to win £1" do
      d2 = FixedOdds.decimal_odds '2'
      d2.profit_on_stake(Money.parse '£1').should == Money.parse('£1')
    end

    it "treats '5' as meaning you have to wager £1 to win £4" do
      d5 = FixedOdds.decimal_odds '5'
      d5.profit_on_stake(Money.parse '£1').should == Money.parse('£4')
    end

    it "treats '1.25' as meaning you have to wager £4 to win £1" do
      d1_25 = FixedOdds.decimal_odds '1.25'
      d1_25.profit_on_stake(Money.parse '£4').should == Money.parse('£1')
    end
  end

  describe ".from_s" do
    describe "bad input" do
      it "rejects garbage" do
        expect {
          FixedOdds.from_s 'garbage'
        }.to raise_error(
          ArgumentError,
          /could not parse "garbage"/
        )
      end
    end

    it "rejects an empty string" do
      expect {
        FixedOdds.from_s ''
      }.to raise_error(
        ArgumentError,
        /could not parse ""/
      )
    end

    describe "fractional odds" do
      it "parses '4/1'" do
        FixedOdds.from_s('4/1').should == FixedOdds.fractional_odds('4/1')
      end

      it "parses 'evens'" do
        FixedOdds.from_s('evens').should == FixedOdds.fractional_odds('1/1')
      end

      it "parses 'even money'" do
        FixedOdds.from_s('even money').should == FixedOdds.fractional_odds('1/1')
      end

      it "parses '4/1 against'" do
        FixedOdds.from_s('4/1 against').should == FixedOdds.fractional_odds('4/1')
      end

      it "parses '4/1 on'" do
        FixedOdds.from_s('4/1 on').should == FixedOdds.fractional_odds('1/4')
      end

      it "parses '4-to-1'" do
        FixedOdds.from_s('4-to-1').should == FixedOdds.fractional_odds('4/1')
      end

      it "parses '4-to-1 against'" do
        FixedOdds.from_s('4-to-1 against').should == FixedOdds.fractional_odds('4/1')
      end

      it "parses '4-to-1 on'" do
        FixedOdds.from_s('4-to-1 on').should == FixedOdds.fractional_odds('1/4')
      end

      it "raises an error for a zero denominator" do
        expect {
          FixedOdds.from_s '4/0'
        }.to raise_error(
          ZeroDivisionError
        )
      end
    end

    describe "moneyline odds" do
      it "parses positive moneyline odds" do 
        FixedOdds.from_s('+400').should == FixedOdds.moneyline_odds('+400')
      end

      it "parses negative moneyline odds" do
        FixedOdds.from_s('-400').should == FixedOdds.moneyline_odds('-400')
      end
    end

    describe "decimal odds" do
      it "parses integral odds of '2' as decimal odds, not as fractional odds of '2/1'" do
        decimal_odds_2 = FixedOdds.from_s '2'

        decimal_odds_2.should == FixedOdds.decimal_odds('2')
        decimal_odds_2.should_not == FixedOdds.fractional_odds('2/1')
      end

      it "should parse floating-point odds" do
        FixedOdds.from_s('1.25').should == FixedOdds.decimal_odds('1.25')
      end
    end
  end

  describe "#==" do
    it "treats equivalent fractions equally" do 
      FixedOdds.fractional_odds('100/30').should == FixedOdds.fractional_odds('10/3')
    end

    it "recognises '1/1' and '2' are the same" do
      FixedOdds.fractional_odds('1/1').should == FixedOdds.decimal_odds('2')
    end

    it "recognises '4/1' and '5' are the same" do
      FixedOdds.fractional_odds('4/1').should == FixedOdds.decimal_odds('5')
    end

    it "recognises '1/4' and '1.25' are the same" do
      FixedOdds.fractional_odds('1/4').should == FixedOdds.decimal_odds('1.25')
    end

    it "recognises '4/1' and '+400' are the same" do
      FixedOdds.fractional_odds('4/1').should == FixedOdds.moneyline_odds('+400')
    end

    it "recognises '1/4' and '-400' are the same" do
      FixedOdds.fractional_odds('1/4').should == FixedOdds.moneyline_odds('-400')
    end

    it "recognises '+100' and '-100' are the same" do
      FixedOdds.moneyline_odds('+100').should == FixedOdds.moneyline_odds('-100')
    end
  end

  describe "#to_s" do
    it "is in fractional odds format" do
      FixedOdds.from_s('+400').to_s.should == '4/1'
    end
  end

  describe "#to_s_fractional" do
    it "displays '4/1' as '4/1'" do
      FixedOdds.fractional_odds('4/1').to_s_fractional.should == '4/1'
    end

    it "is in the lowest terms" do
      FixedOdds.fractional_odds('100/30').to_s_fractional.should == '10/3'
    end

    it "is '4/1' for '+400'" do
      FixedOdds.moneyline_odds('+400').to_s_fractional.should == '4/1'
    end

    it "is '4/1' for '5'" do 
      FixedOdds.decimal_odds('5').to_s_fractional.should == '4/1'
    end

    it "is '1/1' for '+100'" do
      FixedOdds.moneyline_odds('+100').to_s_fractional.should == '1/1'
    end

    it "is '1/1' for '-100'" do
      FixedOdds.moneyline_odds('-100').to_s_fractional.should == '1/1'
    end
  end

  describe "#to_s_moneyline" do
    it "is '+400' for '+400'" do
      FixedOdds.moneyline_odds('+400').to_s_moneyline.should == ('+400')
    end

    it "is '-100' for '+100' as '-100'" do
      FixedOdds.moneyline_odds('+100').to_s_moneyline.should == ('-100')
    end

    it "is '-100' as '-100'" do
      FixedOdds.moneyline_odds('-100').to_s_moneyline.should == ('-100')
    end

    it "is '+400' for '4/1'" do
      FixedOdds.fractional_odds('4/1').to_s_moneyline.should == '+400'
    end

    it "is '+400' for '5'" do
      FixedOdds.decimal_odds('5').to_s_moneyline.should == '+400'
    end

    it "is '-400' for '1.25'" do
      FixedOdds.decimal_odds('1.25').to_s_moneyline.should == '-400'
    end
  end

  describe "#to_s_decimal" do
    it "is '1.25' for '1.25'" do
      FixedOdds.decimal_odds('1.25').to_s_decimal.should == '1.25'
    end

    it "is '1.25' for '1/4'" do
      FixedOdds.fractional_odds('1/4').to_s_decimal.should == '1.25'
    end

    it "is '1.25' for '-400'" do
      FixedOdds.moneyline_odds('-400').to_s_decimal.should == '1.25'
    end

    it "is '2' for '+100'" do
      FixedOdds.moneyline_odds('+100').to_s_decimal.should == '2'
    end

    it "is '2' for '-100'" do
      FixedOdds.moneyline_odds('-100').to_s_decimal.should == '2'
    end
  end

  describe "#profit_on_stake" do
    it "is £4 on a £1 stake on a 4/1 bet" do 
      fourToOne = FixedOdds.fractional_odds '4/1'
      fourToOne.profit_on_stake(Money.parse '£1').should == Money.parse('£4')
    end

    it "is £0.25 on a £1 stake with a 1/4 bet" do
      oneToFour = FixedOdds.fractional_odds '1/4'
      oneToFour.profit_on_stake(Money.parse '£1').should == Money.parse('£0.25')
    end

    it "is £11 on £4 on a 11/4 bet" do
      elevenToFour = FixedOdds.fractional_odds '11/4'
      elevenToFour.profit_on_stake(Money.parse '£4').should == Money.parse('£11')
    end
  end

  describe "#total_return_on_stake" do
    specify { FixedOdds.fractional_odds('4/1').total_return_on_stake(Money.parse '£1').should == Money.parse('£5') }
    specify { FixedOdds.fractional_odds('1/4').total_return_on_stake(Money.parse '£100').should == Money.parse('£125') }
  end

  describe "#stake_to_profit" do
    specify { FixedOdds.fractional_odds('1/1').stake_to_profit(Money.parse '£1').should == Money.parse('£1') }
    specify { FixedOdds.fractional_odds('2/1').stake_to_profit(Money.parse '£2').should == Money.parse('£1') }
  end

  describe "object comparison" do
    specify { FixedOdds.from_s('+200').should be < FixedOdds.from_s('-200') }
    specify { FixedOdds.from_s('-200').should be > FixedOdds.from_s('+200') }
  end
end
