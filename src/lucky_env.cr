require "string_scanner"
require "./lucky_env/string_modifier"
require "./lucky_env/*"

module LuckyEnv
  VERSION = "0.1.1"

  # Parses the `file_path`, and loads the results in to `ENV`
  # raises `LuckyEnv::MissingFileError` if the file is missing
  def self.load(file_path : String) : Hash(String, String)
    data = Parser.new.read_file(file_path)

    data.each do |k, v|
      ENV[k] = v
    end

    data
  end

  # Returns `nil` if the file is missing
  def self.load?(file_path : String) : Hash(String, String)?
    if File.exists?(file_path) || File.symlink?(file_path)
      load(file_path)
    end
  end
end
