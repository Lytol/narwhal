require_relative 'test_helper'

describe Narwhal do

  it "should have version" do
    Narwhal::VERSION.must_match /^\d+\.\d+\.\d+$/
  end

end
