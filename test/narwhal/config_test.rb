require_relative '../test_helper'

describe Narwhal::Config do
  subject { Narwhal::Config }

  let(:config) { Narwhal::Config.new({}, "test/fixtures/blank-config.yml") }

  it "should have default `environment`" do
    config.environment.must_equal "development"
  end

  it "should have default `workers`" do
    config.workers.must_equal 2
  end

  it "should raise NoMethodError on bogus attributes" do
    -> {
      config.whatever
    }.must_raise NoMethodError
  end

  describe "when config file does not exist" do
    let(:config) { Narwhal::Config.new({}, "test/fixtures/does-not-exist.yml") }

    it "should raise exception" do
      -> {
        config
      }.must_raise Narwhal::InvalidConfig

    end
  end

  describe "when attributes are provided via `new`" do
    let(:config) { Narwhal::Config.new({ workers: 9 }, "test/fixtures/sample-config.yml") }

    it "should override default attributes" do
      config.workers.must_equal 9
    end

    it "should override config file attributes" do
      config.workers.must_equal 9
    end
  end

  describe "when attributes are provided via config file" do
    let(:config) { Narwhal::Config.new({ workers: 9 }, "test/fixtures/sample-config.yml") }

    it "should override default attributes" do
      config.adapter[:name].must_equal 'redis'
    end

    it "should not override `new` attributes" do
      config.workers.must_equal 9
    end
  end

end
