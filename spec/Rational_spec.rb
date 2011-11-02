require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Rational" do
	describe "#reciprocal" do
		it "should invert the numerator and denominator" do
			rational = Rational('1/2')
			inverted = rational.reciprocal
			inverted.should == Rational('2/1')
			rational.should == Rational('1/2')
		end
	end
end
