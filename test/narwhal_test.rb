require_relative 'test_helper'

describe Narwhal do

  it "should have version" do
    Narwhal::VERSION.must_match /^\d+\.\d+\.\d+$/
  end

  describe ".log" do
    it "should print to stdout"
  end

  describe ".title=" do
    it "should set the process title"
  end
end
