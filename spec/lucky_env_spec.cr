require "./spec_helper"

describe LuckyEnv do
  original_env = ENV.to_h

  around_each do |example|
    restore_env(original_env) { example.run }
  end

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

    context "when no file path is provided, reads the environment file based on the current environment" do
      # Creates a symlink of the env files for testing purposes because
      # they are looked up in the project directory by default.
      env_files = [".env", ".env.test", ".env.production", ".env.development"]
      before_each do
        env_files.each do |f|
          File.link("./spec/support/#{f}", f) if !File.exists?(f)
        end
      end

      after_each do
        env_files.each do |f|
          File.delete(f) if File.exists?(f)
        end
      end

      it "reads development environment file" do
        ENV["LUCKY_ENV"] = "development"
        results = LuckyEnv.load
        results["LUCKY_ENV"].should eq "development"
        ENV["LUCKY_ENV"].should eq "development"
        ENV["DEV_PORT"].should eq "4500"
      end

      it "reads test environment file" do
        ENV["LUCKY_ENV"] = "test"
        results = LuckyEnv.load
        results["LUCKY_ENV"].should eq "test"
        ENV["LUCKY_ENV"].should eq "test"
        ENV["APP_NAME"].should eq "test_app"
      end

      it "reads production environment file" do
        ENV["LUCKY_ENV"] = "production"
        results = LuckyEnv.load
        results["LUCKY_ENV"].should eq "production"
        ENV["SECRET_KEY_BASE"].should eq "Jcj7ki8pFV="
      end

      it "fall back to .env if no environment is set" do
        ENV["LUCKY_ENV"] = "undefined-env"
        results = LuckyEnv.load
        results["LUCKY_ENV"].should eq "development"
        ENV["DEV_PORT"].should eq "3500"
      end
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
      data = results.as(Hash(String, String))
      data["LUCKY_ENV"].should eq "test"
      ENV["LUCKY_ENV"].should eq "test"
    end
  end

  describe ".development?" do
    context "when LUCKY_ENV is not set" do
      it "returns true" do
        ENV.delete("LUCKY_ENV")
        LuckyEnv.development?.should be_true
      end
    end

    context "when LUCKY_ENV is set to 'development'" do
      it "returns true" do
        ENV["LUCKY_ENV"] = "development"
        LuckyEnv.development?.should be_true
      end
    end

    context "when LUCKY_ENV is set to something else" do
      it "returns false" do
        ENV["LUCKY_ENV"] = "test"
        LuckyEnv.development?.should be_false
      end
    end
  end

  describe ".test?" do
    context "when LUCKY_ENV is not set" do
      it "returns false" do
        ENV.delete("LUCKY_ENV")
        LuckyEnv.test?.should be_false
      end
    end

    context "when LUCKY_ENV is set to 'test'" do
      it "returns true" do
        ENV["LUCKY_ENV"] = "test"
        LuckyEnv.test?.should be_true
      end
    end

    context "when LUCKY_ENV is set to something else" do
      it "returns false" do
        ENV["LUCKY_ENV"] = "development"
        LuckyEnv.test?.should be_false
      end
    end
  end

  describe ".production?" do
    context "when LUCKY_ENV is not set" do
      it "returns false" do
        ENV.delete("LUCKY_ENV")
        LuckyEnv.production?.should be_false
      end
    end

    context "when LUCKY_ENV is set to 'production'" do
      it "returns true" do
        ENV["LUCKY_ENV"] = "production"
        LuckyEnv.production?.should be_true
      end
    end

    context "when LUCKY_ENV is set to something else" do
      it "returns false" do
        ENV["LUCKY_ENV"] = "test"
        LuckyEnv.production?.should be_false
      end
    end
  end

  describe ".task?" do
    context "when LUCKY_TASK is set to 'true'" do
      it "returns true" do
        ENV["LUCKY_TASK"] = "true"
        LuckyEnv.task?.should be_true
      end
    end

    context "when LUCKY_TASK is set to '1'" do
      it "returns true" do
        ENV["LUCKY_TASK"] = "1"
        LuckyEnv.task?.should be_true
      end
    end

    context "when LUCKY_TASK is set to something else" do
      it "returns false" do
        ENV["LUCKY_TASK"] = "false"
        LuckyEnv.task?.should be_false
      end
    end

    context "when LUCKY_TASK isn't set" do
      it "returns false" do
        LuckyEnv.task?.should be_false
      end
    end
  end
end

private def restore_env(env, &)
  yield
ensure
  ENV.clear
  env.each { |key, value| ENV[key] = value }
end
