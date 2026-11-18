# rails-truncate-words-fix

Speeds up Active Support's `String#truncate_words` and avoids transient memory use when truncating long strings.

This gem packages the **one-line regex optimization** in [rails/rails#59848](https://github.com/rails/rails/pull/59848). The original Rails regex consumes the entire suffix after the truncation point. This replacement uses a positive lookahead, so it stops matching at the requested boundary without changing the public API.

## Installation

Add this to your Rails application's `Gemfile`:

```ruby
gem "rails-truncate-words-fix", github: "public-law/rails-truncate-words-fix"
```

Then run `bundle install`. No initializer or configuration is required. Once published to RubyGems, use `gem "rails-truncate-words-fix"` instead.

The gem requires `railties` 7.2 through 8.x. Its Railtie loads Active Support's `String#truncate_words` definition before prepending the optimized implementation, during Rails initialization.

## Example

```ruby
"one two three four".truncate_words(2) # => "one two..."
```

## Tests

```sh
ruby -Itest test/truncate_words_test.rb
```

## Why?

The underlying fix replaces `#{sep}.*` with `(?=#{sep})` at the end of Rails' regular expression. Benchmarks and memory measurements are in the [upstream PR](https://github.com/rails/rails/pull/59848).

Once Rails merges and ships the fix, remove this gem from the Gemfile.

MIT licensed.
