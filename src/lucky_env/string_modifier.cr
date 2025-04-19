module StringModifier
  # Removes single or double quotes wrapped around the string
  def remove_wrapped_quotes(string : String) : String
    if (string.starts_with?('"') && string.ends_with?('"')) ||
       (string.starts_with?("'") && string.ends_with?("'"))
      string = string[1..-2]
    end

    string
  end

  # Returns the formatted key string and associated type
  # Default to 'String' if not type is defined
  # All "keys" are uppercase with no spaces
  #
  # ```
  # StringModifier.format_key(ENABLE_CACHE(Bool)) # => (ENABLE_CACHE, Bool)
  # StringModifier.format_key(APP_NAME)           # => (APP_NAME, String)
  # ```
  def format_key(key : String) : Tuple(String, String)
    key = key.upcase.gsub(/\s/, '_')

    regex = /\((?<type>String|Int32|Float64|Bool)\)/i
    type = regex.match(key).try &.["type"] # KEY_NAME(type)
    key = key.gsub(regex, "") # KEY_NAME(type) => KEY_NAME

    if type.nil?
      type = "STRING"
    end

    {key, type}
  end
end
