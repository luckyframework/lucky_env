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

  # A macro that generates method definitions for environment variables,
  # to be accessed in a type-safe manner at compile time.
  #
  # This macro executes an external script (`./static_load_env`) with the
  # provided `env_file_path` to statically load and define the environment
  # variables as methods.
  macro static_load(env_file_path)
    {{ run("./static_load_env", env_file_path) }}
  end

  # This is a shorthand for calling `LuckyEnv.static_load(env_file_path)`,
  # but it determines the appropriate environment file dynamically.
  macro static_load
    {{ run("./static_load_env") }}
  end

  # Parses the `file_path`, and loads the results in to `ENV`
  # raises `LuckyEnv::MissingFileError` if the file is missing
  def self.load(file_path : String) : Hash(String, String)
    data = Parser.new.read_file(file_path)[:kv]

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
