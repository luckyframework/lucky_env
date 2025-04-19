# This script generates Crystal method definitions from environment variables.
#
# It reads a `.env` file or an environment-specific `.env` file (e.g., `.env.development`, `.env.test`, `.env.production`)
# based on the value of the `ENV["LUCKY_ENV"]` variable. If no file is specified via command-line arguments,
# it defaults to `.env` or the appropriate environment-specific file.
#
# The generated methods are typed based on the variable type (e.g., String, Int32, Float64, Bool)
# and include optional type annotations for boolean values.
#
# Usage:
#   crystal static_load_env.cr [optional_path_to_env_file]
#
# Env File:
# ```
#  LUCKY_ENV(String)=development
#  DEV_PORT(Int32)=3500
#  ENABLE_CACHE(Bool)=true
# ```
#
# Output:
# ```
# def LuckyEnv.lucky_env : String
#   "development"
# end
# def LuckyEnv.dev_port : Int32
#   3500
# end
# def LuckyEnv.enable_cache? : Bool
#   true
# end
# ```
#
require "string_scanner"
require "./lucky_env/errors"
require "./lucky_env/string_modifier"
require "./lucky_env/parser"

STANDARD_TYPES = {"STRING" => String, "INT32" => Int32, "FLOAT64" => Float64, "BOOL" => Bool}

parser = LuckyEnv::Parser.new
begin
  path = ARGV.size > 0 ? ARGV[0] : nil
  if path.nil?
    path = ".env"
    env = ENV.fetch("LUCKY_ENV", "development")

    if env == "development" && File.exists?("#{path}.development") || File.symlink?("#{path}.development")
      path = "#{path}.development"
    elsif env == "test" && File.exists?("#{path}.test") || File.symlink?("#{path}.test")
      path = "#{path}.test"
    elsif env == "production" && File.exists?("#{path}.production") || File.symlink?("#{path}.production")
      path = "#{path}.production"
    end
  end

  data = parser.read_file(path)
  data[:kv].each do |k, v|
    type = STANDARD_TYPES[data[:kt][k]]
    is_bool = type == Bool ? "?" : ""
    new_value = type == String ? "\"#{v}\"" : v

    puts "def LuckyEnv.#{k.downcase}#{is_bool} : #{type}
        #{new_value}
    end"
  end
rescue ex
  puts ex.message
end
