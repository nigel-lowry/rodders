require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "MutuallyExclusiveCollection" do
  
  before(:each) do    
    @good_team = FixedOdds.from_s '-275'
    @draw = FixedOdds.from_s '+429'
    @bad_team = FixedOdds.from_s '+915'

    @events = MutuallyExclusiveCollection.new [@draw, @bad_team, @good_team]
  end

  describe "#least_likely" do
    it "is the least likely event to occur" do
      @events.least_likely.should == @bad_team
    end
  end

  describe "#most_likely" do
    it "is the most likely event to occur" do
      @events.most_likely.should == @good_team
    end
  end

  describe "#in_descending_probability" do
    it "is in descending probability" do
      @events.in_descending_probability.should == [@good_team, @draw, @bad_team]
    end
  end

  describe "#in_ascending_probability" do
    it "is in ascending probability" do
      @events.in_ascending_probability.should == [@bad_team, @draw, @good_team]
    end
  end
end