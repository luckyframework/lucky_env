module LuckyEnv
  struct Parser
    include StringModifier

    # Returns the key name, type and value
    def parse_value(env_value : String) : NamedTuple(key: String, type: String, value: String)
      scanner = StringScanner.new(env_value)
      key = scanner.scan_until(/=/).try(&.chomp('=').strip)

      if key
        value = scanner.scan_until(/$/).to_s.strip
        value = remove_wrapped_quotes(value)
        key, type = format_key(key)

        {key: key, type: type, value: value}
      else
        raise InvalidEnvFormatError.new <<-ERROR
        Invalid format for ENV. Make sure the value is formatted like this:

        YOUR_KEY=some_value or YOUR_KEY(String|Int32|Float64|Bool)=some_value
        ERROR
      end
    end

    def read_file(file_path : String) : NamedTuple(kv: Hash(String, String), kt: Hash(String, String))
      if File.exists?(file_path) || File.symlink?(file_path)
        hash = Hash(String, String).new  # key name, value
        types = Hash(String, String).new # key name, type name

        File.read_lines(file_path).each do |line|
          string = line.strip
          next if blank?(string)
          next if comment?(string)

          data = parse_value(string)
          key = data[:key]

          if hash.has_key?(key)
            raise LuckyEnv::DuplicateKeyDetectedError.new <<-ERROR
            Duplicate key #{key} found in #{file_path}.
            To ignore a key, place a # at the front of the line like this:

            # YOUR_KEY=ignored_value
            ERROR
          else
            hash[key] = data[:value]
            types[key] = data[:type]
          end
        end

        keys = hash.keys

        hash.transform_values do |value|
          keys.each do |key|
            if value =~ /\$\{#{key}\}/
              value = value.sub("${#{key}}", hash[key])
            else
              value
            end
          end

          value
        end

        {kv: hash, kt: types}
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
