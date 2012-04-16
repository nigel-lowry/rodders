# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "MutuallyExclusiveCollection" do

  context "non-arbitrage methods" do
    before(:each) do    
      @good_team = FixedOdds.from_s '-275'
      @draw = FixedOdds.from_s '+429'
      @bad_team = FixedOdds.from_s '+915'

      @events = MutuallyExclusiveCollection.new [@draw, @bad_team, @good_team]
    end

    subject { @events }

    its(:most_likely) { should == @good_team }
    its(:least_likely) { should == @bad_team }
    its(:in_descending_probability) { should == [@good_team, @draw, @bad_team] }
    its(:in_ascending_probability) { should == [@bad_team, @draw, @good_team] }
  end

  context "decimal odds arbitrage" do
    before(:each) do
      @bookmaker1outcome1 = FixedOdds.from_s '2.25'
      @bookmaker1outcome2 = FixedOdds.from_s '4.9'
      @bookmaker2outcome1 = FixedOdds.from_s '2.43'
      @bookmaker2outcome2 = FixedOdds.from_s '3.85'

      @bookmaker1 = MutuallyExclusiveCollection.new [@bookmaker1outcome1, @bookmaker1outcome2]
      @bookmaker2 = MutuallyExclusiveCollection.new [@bookmaker2outcome1, @bookmaker2outcome2]

      @bookmaker_vulnerable_to_arbitrage = MutuallyExclusiveCollection.new [@bookmaker2outcome1, @bookmaker1outcome2]
    end

    describe "#sum_inverse_outcome" do
      it "is 1.056 for bookmaker 1" do
        @bookmaker1.sum_inverse_outcome.should be_within(0.001).of(1.056)
      end

      it "is 1.051 for bookmaker 2" do
        @bookmaker2.sum_inverse_outcome.should be_within(0.001).of(1.051)
      end
    end

    describe "#rational_bookmaker?" do
      it "is true for bookmaker 1" do
        @bookmaker1.rational_bookmaker?.should be
      end

      it "is true for bookmaker 2" do
        @bookmaker2.rational_bookmaker?.should be
      end

      it "is false for vulnerable bookmaker" do
        @bookmaker_vulnerable_to_arbitrage.rational_bookmaker?.should be_false
      end
    end

    describe "#bookmakers_return_rate" do
      it "is 5.34% for bookmaker 1" do
        @bookmaker1.bookmakers_return_rate.should be_within(0.0001).of(0.0534)
      end

      it "is 4.78% for bookmaker 2" do
        @bookmaker2.bookmakers_return_rate.should be_within(0.0001).of(0.0478)
      end
    end

    describe "#profit_from_total_stake" do
      it "is £4.64 with a £100.00 stake" do
        @bookmaker_vulnerable_to_arbitrage.profit_from_total_stake(Money.from_fixnum(100, :GBP)).should == Money.from_fixnum(4.64, :GBP)
      end
    end

    describe "#profit_percentage" do
      it "is 4.6%" do
        @bookmaker_vulnerable_to_arbitrage.profit_percentage.should be_within(0.001).of(0.046)
      end
    end
  end

  context "fractional odds arbitrage" do
    before(:each) do
      @odds1 = FixedOdds.from_s('2/1')
      @odds2 = FixedOdds.from_s('3/1')

      @bookmaker_vulnerable_to_arbitrage = MutuallyExclusiveCollection.new [@odds1, @odds2]
    end

    subject { @bookmaker_vulnerable_to_arbitrage }

    it "is vulnerable to arbitrage" do
      @bookmaker_vulnerable_to_arbitrage.should_not be_rational_bookmaker
    end

    its(:rational_bookmaker?) { should be_false }
    its(:profit_percentage) { should be_within(0.001).of(0.2) }

    describe "#profit_from_total_stake" do
      it "is £100.00 with a £500.00 stake" do
        @bookmaker_vulnerable_to_arbitrage.profit_from_total_stake(Money.from_fixnum(500, :GBP)).should == Money.from_fixnum(100.00, :GBP)
      end
    end
  end

  context "more than two mutually exclusive events" do
    before(:each) do
      @odds1 = FixedOdds.from_s('2.3')
      @odds2 = FixedOdds.from_s('8.0')
      @odds3 = FixedOdds.from_s('18.0')

      @bookmaker_vulnerable_to_arbitrage = MutuallyExclusiveCollection.new [@odds1, @odds2, @odds3]
    end

    subject { @bookmaker_vulnerable_to_arbitrage }

    its(:rational_bookmaker?) { should be_false }
    its(:sum_inverse_outcome) { should be_within(0.0001).of(0.9709) }
    its(:profit_percentage) { should be_within(0.0001).of(0.0302) }

    describe "#percentages" do
      it "gives the percentages to put on each bet" do
        percentages = @bookmaker_vulnerable_to_arbitrage.percentages
        percentages.should have(3).items
        percentages[@odds1].should be_within(0.0001).of(0.7922)
        percentages[@odds2].should be_within(0.0001).of(0.1472)
        percentages[@odds3].should be_within(0.0001).of(0.0606)
      end
    end

    describe "#bet_amounts_for_total" do
      it "gives the right amounts" do
        total = Money.from_fixnum(500, :GBP)
        amounts = @bookmaker_vulnerable_to_arbitrage.bet_amounts_for_total total
        amounts.should have(3).items
        amounts[@odds1].should == Money.from_fixnum(396.14, :GBP)
        amounts[@odds2].should == Money.from_fixnum(73.57, :GBP)
        amounts[@odds3].should == Money.from_fixnum(30.29, :GBP)
        amounts.values.reduce(:+).should == total
      end
    end

    describe "#profit_from_total_stake" do
      it "gives the right amount" do
        @bookmaker_vulnerable_to_arbitrage.profit_from_total_stake(Money.from_fixnum(500, :GBP)).should == Money.from_fixnum(15.10, :GBP)
      end
    end

    describe "#bet_amounts_for_winnings" do
      it "gives the right amounts" do
        amounts = @bookmaker_vulnerable_to_arbitrage.bet_amounts_for_profit Money.from_fixnum(750, :GBP)
        amounts.should have(3).items
        amounts[@odds1].should == Money.from_fixnum(19675.76, :GBP)
        amounts[@odds2].should == Money.from_fixnum(3654.07, :GBP)
        amounts[@odds3].should == Money.from_fixnum(1504.62, :GBP)
        amounts.values.reduce(:+).should == Money.from_fixnum(24834.445, :GBP)
      end
    end

    describe "#total_stake_for_profit" do
      it "gives the right amounts" do
        @bookmaker_vulnerable_to_arbitrage.total_stake_for_profit(Money.from_fixnum(750, :GBP)).should == Money.from_fixnum(24834.44, :GBP)
      end
    end

  end

end