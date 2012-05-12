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

    specify { FixedOdds.fractional_odds('4/1 against').should == FixedOdds.fractional_odds('4/1') }
    specify { FixedOdds.fractional_odds('4/1 on').should == FixedOdds.fractional_odds('1/4') }
    specify { FixedOdds.fractional_odds('evens').should == FixedOdds.fractional_odds('1/1') }
    specify { FixedOdds.fractional_odds('even money').should == FixedOdds.fractional_odds('1/1') }
    specify { FixedOdds.fractional_odds('4-to-1').should == FixedOdds.fractional_odds('4/1') }
    specify { FixedOdds.fractional_odds('4-to-1 against').should == FixedOdds.fractional_odds('4/1') }
    specify { FixedOdds.fractional_odds('4-to-1 on').should == FixedOdds.fractional_odds('1/4') }

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

    specify { FixedOdds.moneyline_odds('+400').profit_on_stake(Money.parse '£100').should == Money.parse('£400') }
    specify { FixedOdds.moneyline_odds('+100').profit_on_stake(Money.parse '£100').should == Money.parse('£100') }

    specify { FixedOdds.moneyline_odds('-400').profit_on_stake(Money.parse '£400').should == Money.parse('£100') }
    specify { FixedOdds.moneyline_odds('-100').profit_on_stake(Money.parse '£100').should == Money.parse('£100') }
    specify { FixedOdds.moneyline_odds('+100').profit_on_stake(Money.parse '£100').should == Money.parse('£100') }
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

    specify { FixedOdds.decimal_odds('2').profit_on_stake(Money.parse '£1').should == Money.parse('£1') }
    specify { FixedOdds.decimal_odds('5').profit_on_stake(Money.parse '£1').should == Money.parse('£4') }
    specify { FixedOdds.decimal_odds('1.25').profit_on_stake(Money.parse '£4').should == Money.parse('£1') }
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
      specify { FixedOdds.from_s('4/1').should == FixedOdds.fractional_odds('4/1') }
      specify { FixedOdds.from_s('evens').should == FixedOdds.fractional_odds('1/1') }
      specify { FixedOdds.from_s('even money').should == FixedOdds.fractional_odds('1/1') }
      specify { FixedOdds.from_s('4/1 against').should == FixedOdds.fractional_odds('4/1') }
      specify { FixedOdds.from_s('4/1 on').should == FixedOdds.fractional_odds('1/4') }
      specify { FixedOdds.from_s('4-to-1').should == FixedOdds.fractional_odds('4/1') }
      specify { FixedOdds.from_s('4-to-1 against').should == FixedOdds.fractional_odds('4/1') }
      specify { FixedOdds.from_s('4-to-1 on').should == FixedOdds.fractional_odds('1/4') }

      it "raises an error for a zero numerator" do
        expect {
          FixedOdds.from_s '0/4'
        }.to raise_error(
          ArgumentError
        )
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

    it "recognises '+100' and '-100' are the same" do
      FixedOdds.moneyline_odds('+100').should == FixedOdds.moneyline_odds('-100')
    end

    specify { FixedOdds.fractional_odds('1/1').should == FixedOdds.decimal_odds('2') }
    specify { FixedOdds.fractional_odds('4/1').should == FixedOdds.decimal_odds('5') }
    specify { FixedOdds.fractional_odds('1/4').should == FixedOdds.decimal_odds('1.25') }
    specify { FixedOdds.fractional_odds('4/1').should == FixedOdds.moneyline_odds('+400') }
    specify { FixedOdds.fractional_odds('1/4').should == FixedOdds.moneyline_odds('-400') }
  end

  describe "#to_s" do
    it "is in fractional odds format" do
      FixedOdds.from_s('+400').to_s.should == '4/1'
    end
  end

  describe "#to_s_fractional" do
    specify { FixedOdds.fractional_odds('4/1').to_s_fractional.should == '4/1' }
    specify { FixedOdds.fractional_odds('100/30').to_s_fractional.should == '10/3' }
    specify { FixedOdds.moneyline_odds('+400').to_s_fractional.should == '4/1' }
    specify { FixedOdds.decimal_odds('5').to_s_fractional.should == '4/1' }
    specify { FixedOdds.moneyline_odds('+100').to_s_fractional.should == '1/1' }
    specify { FixedOdds.moneyline_odds('-100').to_s_fractional.should == '1/1' }
  end

  describe "#to_s_moneyline" do
    specify { FixedOdds.moneyline_odds('+400').to_s_moneyline.should == ('+400') }
    specify { FixedOdds.moneyline_odds('+100').to_s_moneyline.should == ('-100') }
    specify { FixedOdds.moneyline_odds('-100').to_s_moneyline.should == ('-100') }
    specify { FixedOdds.fractional_odds('4/1').to_s_moneyline.should == '+400' }
    specify { FixedOdds.decimal_odds('5').to_s_moneyline.should == '+400' }
    specify { FixedOdds.decimal_odds('1.25').to_s_moneyline.should == '-400' }
  end

  describe "#to_s_decimal" do
    specify { FixedOdds.decimal_odds('1.25').to_s_decimal.should == '1.25' }
    specify { FixedOdds.fractional_odds('1/4').to_s_decimal.should == '1.25' }
    specify { FixedOdds.moneyline_odds('-400').to_s_decimal.should == '1.25' }
    specify { FixedOdds.moneyline_odds('+100').to_s_decimal.should == '2' }
    specify { FixedOdds.moneyline_odds('-100').to_s_decimal.should == '2' }
  end

  describe "#profit_on_stake" do
    specify { FixedOdds.fractional_odds('4/1').profit_on_stake(Money.parse '£1').should == Money.parse('£4') }
    specify { FixedOdds.fractional_odds('1/4').profit_on_stake(Money.parse '£1').should == Money.parse('£0.25') }
    specify { FixedOdds.fractional_odds('11/4').profit_on_stake(Money.parse '£4').should == Money.parse('£11') }
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
