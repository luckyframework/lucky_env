require "string_scanner"
require "./lucky_env/string_modifier"
require "./lucky_env/*"

module LuckyEnv
  VERSION = "0.1.0"

  # Parses the `file_path`, and loads the results in to `ENV`
  def self.load(file_path : String) : Hash(String, String)
    data = Parser.new.read_file(file_path)

    data.each do |k, v|
      ENV[k] = v
    end

    data
  end
end
