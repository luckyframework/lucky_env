require "./spec_helper"

describe LuckyEnv do
  describe "load" do
    it "reads the file, loads the results in to ENV, and returns the results" do
      results = LuckyEnv.load("./spec/support/.env.test")
      results["LUCKY_ENV"].should eq "test"
      ENV["LUCKY_ENV"].should eq "test"
    end

    it "overrides ENV values already set" do
      results = LuckyEnv.load("./spec/support/.env")
      results["LUCKY_ENV"].should eq "development"
      ENV["LUCKY_ENV"].should eq "development"
      ENV["DEV_PORT"].should eq "3500"

      results = LuckyEnv.load("./spec/support/.env.test")
      results["LUCKY_ENV"].should eq "test"
      ENV["LUCKY_ENV"].should eq "test"
      ENV["DEV_PORT"].should eq "3500"
    end
  end

  describe "load?" do
    it "returns nil when the file doesn't exist" do
      results = LuckyEnv.load?("./spec/support/env.test")
      results.should eq(nil)
    end

    it "loads the ENV if the file exists" do
      results = LuckyEnv.load?("./spec/support/.env.test")
      results.should_not eq(nil)
      data = results.not_nil!
      data["LUCKY_ENV"].should eq "test"
      ENV["LUCKY_ENV"].should eq "test"
    end
  end
end
