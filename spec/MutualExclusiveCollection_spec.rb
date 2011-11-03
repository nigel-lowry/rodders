require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "MutuallyExclusiveCollection" do
  
  before(:each) do    
    @chelsea = FixedOdds.from_s '-275'
    @draw = FixedOdds.from_s '+429'
    @accrington_stanley = FixedOdds.from_s '+915'

    @events = MutuallyExclusiveCollection.new [@draw, @accrington_stanley, @chelsea]
  end

  it "should return Accrington Stanley as the underdog" do
  	@events.underdog.should == @accrington_stanley
  end

  it "should return Chelsea as the favorite" do
  	@events.favorite.should == @chelsea
  end

  it "should return the events in descending probability" do
  	@events.in_descending_probability.should == [@chelsea, @draw, @accrington_stanley]
  end

  it "should return the events in ascending probability" do
  	@events.in_ascending_probability.should == [@accrington_stanley, @draw, @chelsea]
  end

end