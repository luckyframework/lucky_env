require "string_scanner"
require "./lucky_env/errors"
require "./lucky_env/string_modifier"
require "./lucky_env/parser"

STANDARD_TYPES = {"STRING" => String, "INT32" => Int32, "FLOAT64" => Float64, "BOOL" => Bool}

parser = LuckyEnv::Parser.new
begin
  data = parser.read_file(".env")
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
