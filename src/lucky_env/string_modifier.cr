module StringModifier
  # Removes single or double quotes wrapped around the string
  def remove_wrapped_quotes(string : String) : String
    if (string.starts_with?('"') && string.ends_with?('"')) ||
       (string.starts_with?("'") && string.ends_with?("'"))
      string = string[1..-2]
    end

    string
  end

  # All "keys" are uppercase with no spaces
  def format_key(key : String) : String
    key.upcase.gsub(/\s/, '_')
  end
end
