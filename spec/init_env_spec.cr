{% skip_file if compare_versions(Crystal::VERSION, "1.16.0") < 0 %}
require "./spec_helper"

# Must be called up here, otherwise crystal throws "Error: can't declare def dynamically" error
LuckyEnv.init_env("./spec/support/.env")

describe "loading of env variables as method definitions" do
  it "loads the ENV as method definitions" do
    LuckyEnv.load("./spec/support/.env")

    LuckyEnv.asset_host.should eq "https://luckyframework.org"
    LuckyEnv.app_name.should eq "my_app"
    LuckyEnv.lucky_env.should eq "development"
    LuckyEnv.enable_cache?.should eq true
    LuckyEnv.dev_port.should eq 3500
    LuckyEnv.secret_key_base.should eq "j5I0VrpzT1Of7dhCA="
    LuckyEnv.env_with_space.should eq "start_end"
    LuckyEnv.db_name.should eq "my_app_development"
    LuckyEnv.literal.should eq "${NOT_EXISTS_ENV}"
    LuckyEnv.exchange_rate.should eq 2.34
    LuckyEnv.host.should eq "0.0.0.0"
  end
end
