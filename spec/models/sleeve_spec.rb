require File.dirname(__FILE__) + '/../spec_helper'

describe Sleeve do
  before(:each) do
    @sleeve = Sleeve.new
  end

  it "should be valid" do
    @sleeve.title = "Staff Applicaiton"
    @sleeve.should be_valid
  end
end
