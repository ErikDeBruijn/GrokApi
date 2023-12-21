# GrokApi

The is an experiment out of curiosity to see if Grok, X's Brand new AI can be used programmatically.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add grok_api

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install grok_api

## Usage

```ruby
client = GrokApi::Client.new
client.start_conversation
client.chat do
  say "Is the Improbability Drive incredible, or just highly improbable?"
  chat!
end
```

```md
2023-12-21 01:24:00 +0100: 💬 New conversation started on "Is the Improbability Drive incredible, or just hig"
2023-12-21 01:24:00 +0100: 💬 You: Is the Improbability Drive incredible, or just highly improbable?
Going to send request... ConversationId: 1737623745068449792
2023-12-21 01:24:00 +0100: 🤖 Grok: The Improbability Drive is, in fact, incredibly improbable. It's so improbable that it's almost impossible, which is what makes it so incredible. It's like finding a functioning smartphone in a pile of rocks - highly improbable, yet quite incredible if it actually happens.
```

## ToDo's:
- [ ] auto start a conversation if we don't have one yet `start_conversation unless @conversationId`
- [ ] use streaming API to parse messages during flushing of the output buffer

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/erikdebruijn/GrokApi. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/GrokApi/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GrokApi project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/GrokApi/blob/main/CODE_OF_CONDUCT.md).
