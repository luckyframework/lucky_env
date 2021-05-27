module LuckyEnv
  struct Parser
    include StringModifier

    def parse_value(env_value : String) : Tuple(String, String)
      scanner = StringScanner.new(env_value)
      key = scanner.scan_until(/=/).try(&.chomp('=').strip)

      if key
        value = scanner.scan_until(/$/).to_s.strip
        value = remove_wrapped_quotes(value)
        key = format_key(key)

        {key, value}
      else
        raise InvalidEnvFormatError.new <<-ERROR
        Invalid format for ENV. Make sure the value is formatted like this:

        YOUR_KEY=some_value
        ERROR
      end
    end

    def read_file(file_path : String) : Hash(String, String)
      if File.exists?(file_path) || File.symlink?(file_path)
        hash = Hash(String, String).new
        File.read_lines(file_path).each do |line|
          string = line.strip
          next if blank?(string)
          next if comment?(string)
          key, value = parse_value(string)

          hash[key] = value
        end

        hash
      else
        raise MissingFileError.new <<-ERROR
        The file #{file_path} could not be found.
        ERROR
      end
    end

    private def blank?(string : String) : Bool
      string.empty?
    end

    private def comment?(string : String) : Bool
      string.starts_with?('#')
    end
  end
end
