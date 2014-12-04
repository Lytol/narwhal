require_relative '../test_helper'

describe Narwhal::Master do

  it "should set environment"
  it "should set pid"

  describe "#run!" do

    Narwhal::Master::SIGNALS.each do |sig|
      it "should trap #{sig}"
    end

  end
end
