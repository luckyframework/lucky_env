require "string_scanner"
require "./lucky_env/string_modifier"
require "./lucky_env/*"

module LuckyEnv
  VERSION      = {{ `shards version "#{__DIR__}"`.chomp.stringify }}
  ENVIRONMENTS = {} of String => String

  macro add_env(name, env_file)
    LuckyEnv::ENVIRONMENTS[{{ name.id.stringify }}] = {{ env_file }}

    # Check if the current `environment` is `{{ name.id.stringify }}`.
    def LuckyEnv.{{ name.id }}?
      environment == {{ name.id.stringify }}
    end
  end

  # Load the results of parsing the env file (see `add_env`) associated with the
  # current Lucky `environment` into `ENV`.
  #
  # If the environment is unknown, it raises an `UnknownEnvironmentError`.
  # If the associated env file does not exist, it raises a `MissingFileError`.
  def self.load : Hash(String, String)
    if ENVIRONMENTS.has_key?(environment)
      load(ENVIRONMENTS[environment])
    else
      raise UnknownEnvironmentError.new <<-ERROR
      Unknown environment #{environment}. Have you forgotten to add it?

      LuckyEnv.add_env :#{environment}, env_file: File.expand_path(".env.#{environment}")
      ERROR
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

  # Load the results of parsing the env file (see `add_env`) associated with the
  # current Lucky `environment` into `ENV`.
  #
  # If the environment is unknown or the associated env file does not exist, it
  # returns `Nil`.
  def self.load? : Hash(String, String)?
    load?(ENVIRONMENTS[environment]) if ENVIRONMENTS.has_key?(environment)
  end

  # Returns `nil` if the file is missing
  def self.load?(file_path : String) : Hash(String, String)?
    if File.exists?(file_path) || File.symlink?(file_path)
      load(file_path)
    end
  end

  # Check if a [LuckyTask](https://github.com/luckyframework/lucky_task) is
  # currently running.
  def self.task?
    ENV["LUCKY_TASK"] == "true" || ENV["LUCKY_TASK"] == "1"
  end

  # Returns the current Lucky environment (`ENV["LUCKY_ENV"]`).
  #
  # If `ENV["LUCKY_ENV"]` is not set, it defaults to `"development"`.
  def self.environment
    ENV.fetch("LUCKY_ENV", "development")
  end

  add_env :development, env_file: File.expand_path(".env")
  add_env :production, env_file: File.expand_path(".env.production")
  add_env :test, env_file: File.expand_path(".env.test")
end
