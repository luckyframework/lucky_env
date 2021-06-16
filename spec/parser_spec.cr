require "./spec_helper"

describe LuckyEnv::Parser do
  describe "parse_value" do
    it "returns a tuple with the key and value" do
      value = "NORMAL_ENV=development"
      data = parser.parse_value(value)
      data[0].should eq "NORMAL_ENV"
      data[1].should eq "development"

      value = "ENV_AS_NUMBER=3500"
      data = parser.parse_value(value)
      data[0].should eq "ENV_AS_NUMBER"
      data[1].should eq "3500"

      value = "ENV_WITH_EQUALS=j5I0VrpzT1Of7dhCA="
      data = parser.parse_value(value)
      data[0].should eq "ENV_WITH_EQUALS"
      data[1].should eq "j5I0VrpzT1Of7dhCA="

      value = %<ENV_WITH_QUOTES="https://luckyframework.org">
      data = parser.parse_value(value)
      data[0].should eq "ENV_WITH_QUOTES"
      data[1].should eq "https://luckyframework.org"

      value = %<ENV_WITH_SINGLE_QUOTES='1 + 1'>
      data = parser.parse_value(value)
      data[0].should eq "ENV_WITH_SINGLE_QUOTES"
      data[1].should eq "1 + 1"

      value = "ENV_WITH_SPACE = start_end "
      data = parser.parse_value(value)
      data[0].should eq "ENV_WITH_SPACE"
      data[1].should eq "start_end"

      value = "little_env=ok"
      data = parser.parse_value(value)
      data[0].should eq "LITTLE_ENV"
      data[1].should eq "ok"

      value = "Wonky Env=wat"
      data = parser.parse_value(value)
      data[0].should eq "WONKY_ENV"
      data[1].should eq "wat"

      value = "ENV_WITH_NO_VALUE="
      data = parser.parse_value(value)
      data[0].should eq "ENV_WITH_NO_VALUE"
      data[1].should eq ""
    end
  end

  describe "read_file" do
    it "returns a Hash with all the loaded key/values" do
      data = parser.read_file("./spec/support/.env")

      typeof(data).should eq Hash(String, String)
      data["LUCKY_ENV"].should eq "development"
      data["DEV_PORT"].should eq "3500"
      data["SECRET_KEY_BASE"].should eq "j5I0VrpzT1Of7dhCA="
      data["ASSET_HOST"].should eq "https://luckyframework.org"
      data["ENV_WITH_SPACE"].should eq "start_end"
    end
  end
end

private def parser : LuckyEnv::Parser
  LuckyEnv::Parser.new
end
