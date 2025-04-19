require "./spec_helper"

describe LuckyEnv::Parser do
  describe "parse_value" do
    it "returns a tuple with the key and value" do
      value = "NORMAL_ENV=development"
      data = parser.parse_value(value)
      data[:key].should eq "NORMAL_ENV"
      data[:value].should eq "development"

      value = "ENV_AS_NUMBER=3500"
      data = parser.parse_value(value)
      data[:key].should eq "ENV_AS_NUMBER"
      data[:value].should eq "3500"

      value = "ENV_WITH_EQUALS=j5I0VrpzT1Of7dhCA="
      data = parser.parse_value(value)
      data[:key].should eq "ENV_WITH_EQUALS"
      data[:value].should eq "j5I0VrpzT1Of7dhCA="

      value = %<ENV_WITH_QUOTES="https://luckyframework.org">
      data = parser.parse_value(value)
      data[:key].should eq "ENV_WITH_QUOTES"
      data[:value].should eq "https://luckyframework.org"

      value = %<ENV_WITH_SINGLE_QUOTES='1 + 1'>
      data = parser.parse_value(value)
      data[:key].should eq "ENV_WITH_SINGLE_QUOTES"
      data[:value].should eq "1 + 1"

      value = "ENV_WITH_SPACE = start_end "
      data = parser.parse_value(value)
      data[:key].should eq "ENV_WITH_SPACE"
      data[:value].should eq "start_end"

      value = "little_env=ok"
      data = parser.parse_value(value)
      data[:key].should eq "LITTLE_ENV"
      data[:value].should eq "ok"

      value = "Wonky Env=wat"
      data = parser.parse_value(value)
      data[:key].should eq "WONKY_ENV"
      data[:value].should eq "wat"

      value = "ENV_WITH_NO_VALUE="
      data = parser.parse_value(value)
      data[:key].should eq "ENV_WITH_NO_VALUE"
      data[:value].should eq ""
    end
  end

  describe "read_file" do
    it "returns a Hash with all the loaded key/values" do
      data = parser.read_file("./spec/support/.env")[:kv]

      typeof(data).should eq Hash(String, String)
      data["LUCKY_ENV"].should eq "development"
      data["DEV_PORT"].should eq "3500"
      data["SECRET_KEY_BASE"].should eq "j5I0VrpzT1Of7dhCA="
      data["ASSET_HOST"].should eq "https://luckyframework.org"
      data["ENV_WITH_SPACE"].should eq "start_end"
      data["APP_NAME"].should eq "my_app"
      data["DB_NAME"].should eq "my_app_development"
      data["LITERAL"].should eq "${NOT_EXISTS_ENV}"
      data["DOMAIN"].should eq "localhost"
      data["DB_PORT"].should eq "5430"
      data["HOST"].should eq "0.0.0.0"
      data["ENABLE_CACHE"].should eq "true"
    end

    it "returns a Hash with all the loaded key/types" do
      data = parser.read_file("./spec/support/.env")[:kt]

      typeof(data).should eq Hash(String, String)
      data["DOMAIN"].should eq "STRING"
      data["DB_PORT"].should eq "INT32"
      data["HOST"].should eq "STRING"
      data["ENABLE_CACHE"].should eq "BOOL"
    end

    it "raises on duplicate keys detected" do
      expect_raises(LuckyEnv::DuplicateKeyDetectedError, /Duplicate key HOST found in \.\/spec\/support\/\.badenv/) do
        parser.read_file("./spec/support/.badenv")
      end
    end
  end
end

private def parser : LuckyEnv::Parser
  LuckyEnv::Parser.new
end
