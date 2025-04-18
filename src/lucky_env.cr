require "string_scanner"
require "./lucky_env/string_modifier"
require "./lucky_env/*"

module LuckyEnv
  VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify }}

  macro add_env(name)
    def LuckyEnv.{{ name.id }}? : Bool
      environment == {{ name.id.stringify }}
    end
  end

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


  # Loads the appropriate environment file from the project root directory based on the value of `ENV["LUCKY_ENV"]`.
  #
  # This method attempts to read one of the following files depending on the environment:
  # - `.env.development` for the development environment
  # - `.env.production` for the production environment
  # - `.env.testing` for the testing environment
  #
  # If no specific file is found for the current environment, it falls back to reading `.env`.
  # raises LuckyEnv::MissingFileError if no environment file is found.
  def self.load : Hash(String, String)
    dev_env = ".env.development"
    prod_env = ".env.production"
    test_env = ".env.test"

    if LuckyEnv.development? && self.file_loadable?(dev_env)
      return self.load(dev_env)
    elsif LuckyEnv.production? && self.file_loadable?(prod_env)
      return self.load(prod_env)
    elsif LuckyEnv.test? && self.file_loadable?(test_env)
      return self.load(test_env)
    else
      return load(".env") # fallback to ".env"
    end
  end

  private def self.file_loadable?(file_path : String) : Bool
    File.exists?(file_path) || File.symlink?(file_path)
  end

  def self.task? : Bool
    ENV["LUCKY_TASK"]? == "true" || ENV["LUCKY_TASK"]? == "1"
  end

  def self.environment : String
    ENV.fetch("LUCKY_ENV", "development")
  end

  add_env :development
  add_env :production
  add_env :test
end
