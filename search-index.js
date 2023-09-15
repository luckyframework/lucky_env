crystal_doc_search_index_callback({"repository_name":"lucky_env","body":"# LuckyEnv\n\nYet another environment variable manager. Read from a file like a `.env`\n\n## Installation\n\n1. Add the dependency to your `shard.yml`:\n\n```yaml\ndependencies:\n  lucky_env:\n    github: luckyframework/lucky_env\n```\n\n2. Run `shards install`\n\n## Usage\n\n### Environment variable file\n\nCreate your \"env\" file. Name it whatever you want. Most common is `.env`.\n\nThe file is created with key/value pairs separated by `=`.\n\n```text\nAPP_NAME=my_app\nLUCKY_ENV=development\nDEV_PORT=3002\nDB_NAME=${APP_NAME}_${LUCKY_ENV}\n```\n\n### Crystal code\n\n```crystal\n# This would normally go in your `src/shards.cr` file\nrequire \"lucky_env\"\n\n# Loads the \".env\" file. Raises if it is missing\nLuckyEnv.load(\".env\")\n\n# Use `load?` if the file is optional. \n# This will not raise if the file is missing\nLuckyEnv.load?(\".env\")\n\nENV[\"LUCKY_ENV\"] == \"development\" # => true\n\n# Returns whatever `ENV[\"LUCKY_ENV\"]` is set to, or `\"development\"` if not set.\nLuckyEnv.environment # => \"development\"\n\n# Environment predicates\nLuckyEnv.development? # => true\nLuckyEnv.production? # => false\nLuckyEnv.test? # => false\n```\n\n## Development\n\nInstall shards `shards install`, and start making changes.\nBe sure to run `./bin/ameba`, and the crystal formatter `crystal tool format spec src`.\n\nRead through the issues for things you can work on. If you have an idea, feel free to\nopen a new issue!\n\n## Contributing\n\n1. Fork it (<https://github.com/luckyframework/lucky_env/fork>)\n2. Create your feature branch (`git checkout -b my-new-feature`)\n3. Commit your changes (`git commit -am 'Add some feature'`)\n4. Push to the branch (`git push origin my-new-feature`)\n5. Create a new Pull Request\n\n## Contributors\n\n- [Jeremy Woertink](https://github.com/jwoertink) - creator and maintainer\n","program":{"html_id":"lucky_env/toplevel","path":"toplevel.html","kind":"module","full_name":"Top Level Namespace","name":"Top Level Namespace","abstract":false,"locations":[],"repository_name":"lucky_env","program":true,"enum":false,"alias":false,"const":false,"types":[{"html_id":"lucky_env/LuckyEnv","path":"LuckyEnv.html","kind":"module","full_name":"LuckyEnv","name":"LuckyEnv","abstract":false,"locations":[{"filename":"src/lucky_env.cr","line_number":5,"url":"https://github.com/luckyframework/lucky_env/blob/af6f7f6411c55ebc9590f2a0b12bb11de259fa9d/src/lucky_env.cr#L5"},{"filename":"src/lucky_env/errors.cr","line_number":1,"url":"https://github.com/luckyframework/lucky_env/blob/af6f7f6411c55ebc9590f2a0b12bb11de259fa9d/src/lucky_env/errors.cr#L1"},{"filename":"src/lucky_env/parser.cr","line_number":1,"url":"https://github.com/luckyframework/lucky_env/blob/af6f7f6411c55ebc9590f2a0b12bb11de259fa9d/src/lucky_env/parser.cr#L1"}],"repository_name":"lucky_env","program":false,"enum":false,"alias":false,"const":false,"constants":[{"id":"VERSION","name":"VERSION","value":"{{ (`shards version \\\"/home/runner/work/lucky_env/lucky_env/src\\\"`).chomp.stringify }}"}],"class_methods":[{"html_id":"development?:Bool-class-method","name":"development?","abstract":false,"location":{"filename":"src/lucky_env.cr","line_number":41,"url":"https://github.com/luckyframework/lucky_env/blob/af6f7f6411c55ebc9590f2a0b12bb11de259fa9d/src/lucky_env.cr#L41"},"def":{"name":"development?","return_type":"Bool","visibility":"Public","body":"environment == \"development\""}},{"html_id":"environment:String-class-method","name":"environment","abstract":false,"location":{"filename":"src/lucky_env.cr","line_number":37,"url":"https://github.com/luckyframework/lucky_env/blob/af6f7f6411c55ebc9590f2a0b12bb11de259fa9d/src/lucky_env.cr#L37"},"def":{"name":"environment","return_type":"String","visibility":"Public","body":"ENV.fetch(\"LUCKY_ENV\", \"development\")"}},{"html_id":"load(file_path:String):Hash(String,String)-class-method","name":"load","doc":"Parses the `file_path`, and loads the results in to `ENV`\nraises `LuckyEnv::MissingFileError` if the file is missing","summary":"<p>Parses the <code>file_path</code>, and loads the results in to <code>ENV</code> raises <code><a href=\"LuckyEnv/MissingFileError.html\">LuckyEnv::MissingFileError</a></code> if the file is missing</p>","abstract":false,"args":[{"name":"file_path","external_name":"file_path","restriction":"String"}],"args_string":"(file_path : String) : Hash(String, String)","args_html":"(file_path : String) : Hash(String, String)","location":{"filename":"src/lucky_env.cr","line_number":16,"url":"https://github.com/luckyframework/lucky_env/blob/af6f7f6411c55ebc9590f2a0b12bb11de259fa9d/src/lucky_env.cr#L16"},"def":{"name":"load","args":[{"name":"file_path","external_name":"file_path","restriction":"String"}],"return_type":"Hash(String, String)","visibility":"Public","body":"data = Parser.new.read_file(file_path)\ndata.each do |k, v|\n  ENV[k] = v\nend\ndata\n"}},{"html_id":"load?(file_path:String):Hash(String,String)|Nil-class-method","name":"load?","doc":"Returns `nil` if the file is missing","summary":"<p>Returns <code>nil</code> if the file is missing</p>","abstract":false,"args":[{"name":"file_path","external_name":"file_path","restriction":"String"}],"args_string":"(file_path : String) : Hash(String, String) | Nil","args_html":"(file_path : String) : Hash(String, String) | Nil","location":{"filename":"src/lucky_env.cr","line_number":27,"url":"https://github.com/luckyframework/lucky_env/blob/af6f7f6411c55ebc9590f2a0b12bb11de259fa9d/src/lucky_env.cr#L27"},"def":{"name":"load?","args":[{"name":"file_path","external_name":"file_path","restriction":"String"}],"return_type":"Hash(String, String) | ::Nil","visibility":"Public","body":"if (File.exists?(file_path)) || (File.symlink?(file_path))\n  load(file_path)\nend"}},{"html_id":"production?:Bool-class-method","name":"production?","abstract":false,"location":{"filename":"src/lucky_env.cr","line_number":42,"url":"https://github.com/luckyframework/lucky_env/blob/af6f7f6411c55ebc9590f2a0b12bb11de259fa9d/src/lucky_env.cr#L42"},"def":{"name":"production?","return_type":"Bool","visibility":"Public","body":"environment == \"production\""}},{"html_id":"task?:Bool-class-method","name":"task?","abstract":false,"location":{"filename":"src/lucky_env.cr","line_number":33,"url":"https://github.com/luckyframework/lucky_env/blob/af6f7f6411c55ebc9590f2a0b12bb11de259fa9d/src/lucky_env.cr#L33"},"def":{"name":"task?","return_type":"Bool","visibility":"Public","body":"(ENV[\"LUCKY_TASK\"]? == \"true\") || (ENV[\"LUCKY_TASK\"]? == \"1\")"}},{"html_id":"test?:Bool-class-method","name":"test?","abstract":false,"location":{"filename":"src/lucky_env.cr","line_number":43,"url":"https://github.com/luckyframework/lucky_env/blob/af6f7f6411c55ebc9590f2a0b12bb11de259fa9d/src/lucky_env.cr#L43"},"def":{"name":"test?","return_type":"Bool","visibility":"Public","body":"environment == \"test\""}}],"macros":[{"html_id":"add_env(name)-macro","name":"add_env","abstract":false,"args":[{"name":"name","external_name":"name","restriction":""}],"args_string":"(name)","args_html":"(name)","location":{"filename":"src/lucky_env.cr","line_number":8,"url":"https://github.com/luckyframework/lucky_env/blob/af6f7f6411c55ebc9590f2a0b12bb11de259fa9d/src/lucky_env.cr#L8"},"def":{"name":"add_env","args":[{"name":"name","external_name":"name","restriction":""}],"visibility":"Public","body":"    def LuckyEnv.\n{{ name.id }}\n? : Bool\n      \nenvironment == \n{{ name.id.stringify }}\n\n    \nend\n  \n"}}],"types":[{"html_id":"lucky_env/LuckyEnv/InvalidEnvFormatError","path":"LuckyEnv/InvalidEnvFormatError.html","kind":"class","full_name":"LuckyEnv::InvalidEnvFormatError","name":"InvalidEnvFormatError","abstract":false,"superclass":{"html_id":"lucky_env/Exception","kind":"class","full_name":"Exception","name":"Exception"},"ancestors":[{"html_id":"lucky_env/Exception","kind":"class","full_name":"Exception","name":"Exception"},{"html_id":"lucky_env/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"lucky_env/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/lucky_env/errors.cr","line_number":2,"url":"https://github.com/luckyframework/lucky_env/blob/af6f7f6411c55ebc9590f2a0b12bb11de259fa9d/src/lucky_env/errors.cr#L2"}],"repository_name":"lucky_env","program":false,"enum":false,"alias":false,"const":false,"namespace":{"html_id":"lucky_env/LuckyEnv","kind":"module","full_name":"LuckyEnv","name":"LuckyEnv"}},{"html_id":"lucky_env/LuckyEnv/MissingFileError","path":"LuckyEnv/MissingFileError.html","kind":"class","full_name":"LuckyEnv::MissingFileError","name":"MissingFileError","abstract":false,"superclass":{"html_id":"lucky_env/Exception","kind":"class","full_name":"Exception","name":"Exception"},"ancestors":[{"html_id":"lucky_env/Exception","kind":"class","full_name":"Exception","name":"Exception"},{"html_id":"lucky_env/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"lucky_env/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/lucky_env/errors.cr","line_number":5,"url":"https://github.com/luckyframework/lucky_env/blob/af6f7f6411c55ebc9590f2a0b12bb11de259fa9d/src/lucky_env/errors.cr#L5"}],"repository_name":"lucky_env","program":false,"enum":false,"alias":false,"const":false,"namespace":{"html_id":"lucky_env/LuckyEnv","kind":"module","full_name":"LuckyEnv","name":"LuckyEnv"}},{"html_id":"lucky_env/LuckyEnv/Parser","path":"LuckyEnv/Parser.html","kind":"struct","full_name":"LuckyEnv::Parser","name":"Parser","abstract":false,"superclass":{"html_id":"lucky_env/Struct","kind":"struct","full_name":"Struct","name":"Struct"},"ancestors":[{"html_id":"lucky_env/StringModifier","kind":"module","full_name":"StringModifier","name":"StringModifier"},{"html_id":"lucky_env/Struct","kind":"struct","full_name":"Struct","name":"Struct"},{"html_id":"lucky_env/Value","kind":"struct","full_name":"Value","name":"Value"},{"html_id":"lucky_env/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/lucky_env/parser.cr","line_number":2,"url":"https://github.com/luckyframework/lucky_env/blob/af6f7f6411c55ebc9590f2a0b12bb11de259fa9d/src/lucky_env/parser.cr#L2"}],"repository_name":"lucky_env","program":false,"enum":false,"alias":false,"const":false,"included_modules":[{"html_id":"lucky_env/StringModifier","kind":"module","full_name":"StringModifier","name":"StringModifier"}],"namespace":{"html_id":"lucky_env/LuckyEnv","kind":"module","full_name":"LuckyEnv","name":"LuckyEnv"},"constructors":[{"html_id":"new-class-method","name":"new","abstract":false,"location":{"filename":"src/lucky_env/parser.cr","line_number":2,"url":"https://github.com/luckyframework/lucky_env/blob/af6f7f6411c55ebc9590f2a0b12bb11de259fa9d/src/lucky_env/parser.cr#L2"},"def":{"name":"new","visibility":"Public","body":"x = allocate\nif x.responds_to?(:finalize)\n  ::GC.add_finalizer(x)\nend\nx\n"}}],"instance_methods":[{"html_id":"initialize-instance-method","name":"initialize","abstract":false,"location":{"filename":"src/lucky_env/parser.cr","line_number":2,"url":"https://github.com/luckyframework/lucky_env/blob/af6f7f6411c55ebc9590f2a0b12bb11de259fa9d/src/lucky_env/parser.cr#L2"},"def":{"name":"initialize","visibility":"Public","body":""}},{"html_id":"parse_value(env_value:String):Tuple(String,String)-instance-method","name":"parse_value","abstract":false,"args":[{"name":"env_value","external_name":"env_value","restriction":"String"}],"args_string":"(env_value : String) : Tuple(String, String)","args_html":"(env_value : String) : Tuple(String, String)","location":{"filename":"src/lucky_env/parser.cr","line_number":5,"url":"https://github.com/luckyframework/lucky_env/blob/af6f7f6411c55ebc9590f2a0b12bb11de259fa9d/src/lucky_env/parser.cr#L5"},"def":{"name":"parse_value","args":[{"name":"env_value","external_name":"env_value","restriction":"String"}],"return_type":"Tuple(String, String)","visibility":"Public","body":"scanner = StringScanner.new(env_value)\nkey = (scanner.scan_until(/=/)).try() do |__arg0|\n  (__arg0.chomp('=')).strip\nend\nif key\n  value = (scanner.scan_until(/$/)).to_s.strip\n  value = remove_wrapped_quotes(value)\n  key = format_key(key)\n  {key, value}\nelse\n  raise(InvalidEnvFormatError.new(\"Invalid format for ENV. Make sure the value is formatted like this:\\n\\nYOUR_KEY=some_value\"))\nend\n"}},{"html_id":"read_file(file_path:String):Hash(String,String)-instance-method","name":"read_file","abstract":false,"args":[{"name":"file_path","external_name":"file_path","restriction":"String"}],"args_string":"(file_path : String) : Hash(String, String)","args_html":"(file_path : String) : Hash(String, String)","location":{"filename":"src/lucky_env/parser.cr","line_number":24,"url":"https://github.com/luckyframework/lucky_env/blob/af6f7f6411c55ebc9590f2a0b12bb11de259fa9d/src/lucky_env/parser.cr#L24"},"def":{"name":"read_file","args":[{"name":"file_path","external_name":"file_path","restriction":"String"}],"return_type":"Hash(String, String)","visibility":"Public","body":"if (File.exists?(file_path)) || (File.symlink?(file_path))\n  hash = Hash(String, String).new\n  (File.read_lines(file_path)).each do |line|\n    string = line.strip\n    if blank?(string)\n      next\n    end\n    if comment?(string)\n      next\n    end\n    key, value = parse_value(string)\n    hash[key] = value\n  end\n  keys = hash.keys\n  hash.transform_values do |value|\n    keys.each do |key|\n      if value =~ (/\\$\\{#{key}\\}/)\n        value = value.sub(\"${#{key}}\", hash[key])\n      else\n        value\n      end\n    end\n    value\n  end\nelse\n  raise(MissingFileError.new(\"The file #{file_path} could not be found.\"))\nend"}}]}]},{"html_id":"lucky_env/StringModifier","path":"StringModifier.html","kind":"module","full_name":"StringModifier","name":"StringModifier","abstract":false,"locations":[{"filename":"src/lucky_env/string_modifier.cr","line_number":1,"url":"https://github.com/luckyframework/lucky_env/blob/af6f7f6411c55ebc9590f2a0b12bb11de259fa9d/src/lucky_env/string_modifier.cr#L1"}],"repository_name":"lucky_env","program":false,"enum":false,"alias":false,"const":false,"including_types":[{"html_id":"lucky_env/LuckyEnv/Parser","kind":"struct","full_name":"LuckyEnv::Parser","name":"Parser"}],"instance_methods":[{"html_id":"format_key(key:String):String-instance-method","name":"format_key","doc":"All \"keys\" are uppercase with no spaces","summary":"<p>All &quot;keys&quot; are uppercase with no spaces</p>","abstract":false,"args":[{"name":"key","external_name":"key","restriction":"String"}],"args_string":"(key : String) : String","args_html":"(key : String) : String","location":{"filename":"src/lucky_env/string_modifier.cr","line_number":13,"url":"https://github.com/luckyframework/lucky_env/blob/af6f7f6411c55ebc9590f2a0b12bb11de259fa9d/src/lucky_env/string_modifier.cr#L13"},"def":{"name":"format_key","args":[{"name":"key","external_name":"key","restriction":"String"}],"return_type":"String","visibility":"Public","body":"key.upcase.gsub(/\\s/, '_')"}},{"html_id":"remove_wrapped_quotes(string:String):String-instance-method","name":"remove_wrapped_quotes","doc":"Removes single or double quotes wrapped around the string","summary":"<p>Removes single or double quotes wrapped around the string</p>","abstract":false,"args":[{"name":"string","external_name":"string","restriction":"String"}],"args_string":"(string : String) : String","args_html":"(string : String) : String","location":{"filename":"src/lucky_env/string_modifier.cr","line_number":3,"url":"https://github.com/luckyframework/lucky_env/blob/af6f7f6411c55ebc9590f2a0b12bb11de259fa9d/src/lucky_env/string_modifier.cr#L3"},"def":{"name":"remove_wrapped_quotes","args":[{"name":"string","external_name":"string","restriction":"String"}],"return_type":"String","visibility":"Public","body":"if ((string.starts_with?('\"')) && (string.ends_with?('\"'))) || ((string.starts_with?(\"'\")) && (string.ends_with?(\"'\")))\n  string = string[1..-2]\nend\nstring\n"}}]}]}})