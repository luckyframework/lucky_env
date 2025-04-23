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

  # Generates type-safe method definitions for env variables.
  #
  # Usage:
  #   `LuckyEnv.init_env` or
  #   `LuckyEnv.init_env "/path/to/env-file"`
  #
  # Env File:
  # ```
  # LUCKY_ENV    = development
  # DEV_PORT     = 3500
  # ENABLE_CACHE = true
  # ```
  #
  # Output:
  # ```
  # def LuckyEnv.lucky_env : String
  #   ENV["LUCKY_ENV"]
  # end
  #
  # def LuckyEnv.dev_port : Int32
  #   ENV["DEV_PORT"].to_i
  # end
  #
  # def LuckyEnv.enable_cache? : Bool
  #   ENV["enable_cache"] == "true"
  # end
  # ```
  #
  macro init_env(path = ".env")
    {% env_data = read_file?(path) %}

    {% if env_data.nil? %}
      {{ warning("Skipping generating method definitions for '#{path.id}'. File is empty or does not exits. Did you forget to create it?") }}
    {% else %}

      {% regex = /(?<key>[\w\d_]+)=(?<value>.*)/ %}

      {% for line in env_data.lines %}
        {% line = line.strip.chomp %}
        {% if !line.starts_with?("#") && !line.empty? %}
          {% hash, str = line.scan(/(?<key>[\w\d\_]+)=(?<value>.*)/) %}

          {% if !hash.nil? %}
            {% value = hash["value"] %}
            {% def_name = hash["key"].downcase %}
            {% type = "String" %}

            {% if value =~ /^\d+$/ %}
              {% type = "Int32" %}
            {% elsif value =~ /^\d+\.\d+$/ %}
              {% type = "Float64" %}
            {% elsif value =~ /^true|false$/ %}
              {% type = "Bool" %}
              {% def_name += "?" %}
            {% end %}

            {% key = hash["key"] %}
            def LuckyEnv.{{ def_name.id }} : {{ type.id }}
              {% if type == "Bool" %}
                ENV[{{ key }}] == "true"
              {% elsif type == "Int32" %}
                ENV[{{ key }}].to_i
              {% elsif type == "Float64" %}
                ENV[{{ key }}].to_f
              {% else %}
                ENV[{{ key }}].as({{ type.id }})
              {% end %}
            end
          {% end %}

        {% end %}
      {% end %}
    {% end %}
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
