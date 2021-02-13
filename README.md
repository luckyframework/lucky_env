# Lucky::Env

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
require "lucky_env"

LuckyEnv.load(".env")

ENV["LUCKY_ENV"] == "development"
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
