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


  # {%  parsed_data = however_this_happens %}
  # {% for key, val in parsed_data %}
  #   {% type = some_guesswork_on(val) %}
  #    def self.{{ key }} : {{ type }}
  #       ENV[{{ key.stringify }}].to_some_conversion.as({{ type }})
  #     end
  #  {% end %}
  # {{ p! env_data.id }}
  # {% key = key = scanner.scan_until(/=/).try(&.chomp('=').strip) %}
  # {% matches = line.scan(/(?<key>[\w\d\_]+)=(?<value>.*)/) %}
  macro init_env
    {% env_data = read_file(".env") %}
    {% regex = /(?<key>[\w\d_]+)=(?<value>.*)/ %}

    {% for line in env_data.lines %}
      {% line = line.strip.chomp %}
      {% if !line.starts_with?("#") && !line.empty? %}
        {% hash, str = line.scan(/(?<key>[\w\d\_]+)=(?<value>.*)/) %}
        {% if !hash.nil? %}
          # Determine the return type
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

          # generate the function
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
