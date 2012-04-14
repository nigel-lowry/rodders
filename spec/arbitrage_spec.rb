require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Arbitrage" do
  before(:each) do    
    @bookmaker1outcome1 = FixedOdds.from_s '1.25'
    @bookmaker1outcome2 = FixedOdds.from_s '3.9'
    @bookmaker2outcome1 = FixedOdds.from_s '1.43'
    @bookmaker2outcome2 = FixedOdds.from_s '2.85'

    @bookmaker1 = MutuallyExclusiveCollection.new [@bookmaker1outcome1, @bookmaker1outcome2]
    @bookmaker2 = MutuallyExclusiveCollection.new [@bookmaker2outcome1, @bookmaker2outcome2]
  end

  describe "sum_inverse_outcome" do
    it "is 1.056 for bookmaker 1" do
      @bookmaker1.sum_inverse_outcome.should be_within(0.001).of(1.056)
    end

    it "is 1.051 for bookmaker 2" do
      @bookmaker2.sum_inverse_outcome.should be_within(0.001).of(1.051)
    end
  end
end