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

  describe ".development?" do
    context "when LUCKY_ENV is not set" do
      it "returns true" do
        with_env("LUCKY_ENV", nil) do
          LuckyEnv.development?.should be_true
        end
      end
    end

    context "when LUCKY_ENV is set to 'development'" do
      it "returns true" do
        with_env("LUCKY_ENV", "development") do
          LuckyEnv.development?.should be_true
        end
      end
    end

    context "when LUCKY_ENV is set to something else" do
      it "returns false" do
        with_env("LUCKY_ENV", "test") do
          LuckyEnv.development?.should be_false
        end
      end
    end
  end

  describe ".test?" do
    context "when LUCKY_ENV is not set" do
      it "returns false" do
        with_env("LUCKY_ENV", nil) do
          LuckyEnv.test?.should be_false
        end
      end
    end

    context "when LUCKY_ENV is set to 'test'" do
      it "returns true" do
        with_env("LUCKY_ENV", "test") do
          LuckyEnv.test?.should be_true
        end
      end
    end

    context "when LUCKY_ENV is set to something else" do
      it "returns false" do
        with_env("LUCKY_ENV", "development") do
          LuckyEnv.test?.should be_false
        end
      end
    end
  end

  describe ".production?" do
    context "when LUCKY_ENV is not set" do
      it "returns true" do
        with_env("LUCKY_ENV", nil) do
          LuckyEnv.production?.should be_false
        end
      end
    end

    context "when LUCKY_ENV is set to 'production'" do
      it "returns true" do
        with_env("LUCKY_ENV", "production") do
          LuckyEnv.production?.should be_true
        end
      end
    end

    context "when LUCKY_ENV is set to something else" do
      it "returns false" do
        with_env("LUCKY_ENV", "test") do
          LuckyEnv.production?.should be_false
        end
      end
    end
  end

  describe ".task?" do
    context "when LUCKY_TASK is set to 'true'" do
      it "returns true" do
        with_env("LUCKY_TASK", "true") do
          LuckyEnv.task?.should be_true
        end
      end
    end

    context "when LUCKY_TASK is set to '1'" do
      it "returns true" do
        with_env("LUCKY_TASK", "1") do
          LuckyEnv.task?.should be_true
        end
      end
    end

    context "when LUCKY_TASK is set to something else" do
      it "returns false" do
        with_env("LUCKY_TASK", "false") do
          LuckyEnv.task?.should be_false
        end
      end
    end
  end
end

private def with_env(key, value, &block)
  original_value = ENV[key]?
  ENV[key] = value
  block.call
ensure
  ENV[key] = original_value
end
