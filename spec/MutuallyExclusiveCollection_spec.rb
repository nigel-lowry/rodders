require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "MutuallyExclusiveCollection" do
  
  before(:each) do    
    @good_team = FixedOdds.from_s '-275'
    @draw = FixedOdds.from_s '+429'
    @bad_team = FixedOdds.from_s '+915'

    @events = MutuallyExclusiveCollection.new [@draw, @bad_team, @good_team]
  end

  it "should return the bad team as the underdog" do
    @events.underdog.should == @bad_team
  end

  it "should return the good team as the favorite" do
    @events.favorite.should == @good_team
  end

  it "should return the events in descending probability" do
    @events.in_descending_probability.should == [@good_team, @draw, @bad_team]
  end

  it "should return the events in ascending probability" do
    @events.in_ascending_probability.should == [@bad_team, @draw, @good_team]
  end

end