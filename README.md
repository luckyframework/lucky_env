# LuckyEnv

Yet another environment variable manager. Read from a file like a `.env`

## Installation

1. Add the dependency to your `shard.yml`:

```yaml
dependencies:
  lucky_env:
    github: luckyframework/lucky_env
```

2. Run `shards install`

## Usage

### Environment variable file

Create your "env" file. Name it whatever you want. Most common is `.env`.

The file is created with key/value pairs separated by `=`.

```text
LUCKY_ENV=development
DEV_PORT=3002
```

### Crystal code

```crystal
# This would normally go in your `src/shards.cr` file
require "lucky_env"

# Loads the ".env" file. Raises if it is missing
LuckyEnv.load(".env")

# Use `load?` if the file is optional. 
# This will not raise if the file is missing
LuckyEnv.load?(".env")

ENV["LUCKY_ENV"] == "development" # => true

# Returns whatever `ENV["LUCKY_ENV"]` is set to, or `"development"` if not set.
LuckyEnv.environment # => "development"

# Environment predicates
LuckyEnv.development? # => true
LuckyEnv.production? # => false
LuckyEnv.test? # => false
```

## Development

Install shards `shards install`, and start making changes.
Be sure to run `./bin/ameba`, and the crystal formatter `crystal tool format spec src`.

Read through the issues for things you can work on. If you have an idea, feel free to
open a new issue!

## Contributing

1. Fork it (<https://github.com/luckyframework/lucky_env/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Jeremy Woertink](https://github.com/jwoertink) - creator and maintainer
