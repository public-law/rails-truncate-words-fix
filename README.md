# rails-truncate-words-fix

Speeds up Active Support's `String#truncate_words` and avoids transient memory use when truncating long strings.

This gem packages the **one-line regex optimization** in [rails/rails#59848](https://github.com/rails/rails/pull/59848). The original Rails regex consumes the entire suffix after the truncation point. This replacement uses a positive lookahead, so it stops matching at the requested boundary without changing the public API.


## To verify it's installed

Use the Rails Console:

```ruby
[1] pry(main)> String.instance_method(:truncate_words).owner
=> RailsTruncateWordsFix::Patch
```


## Additional information

**Speed (`benchmark-ips`, Ruby 4.0.9)**

| Scenario                                  | current    | lookahead  | Improvement |
| ----------------------------------------- | ---------- | ---------- | ----------- |
| Short string, no truncation               | 299k i/s   | 296k i/s   | ≈ same      |
| 100k char string, truncate to 10 words    | 2.8k i/s   |  295k i/s  | **106×**    |
| 100k char string, truncate to 100 words   | 2.7k i/s   |  182k i/s  | **67×**     |
| Medium string, no truncation needed       | 6.6k i/s   | 6.7k i/s   | ≈ same      |

Source and full output: https://gist.github.com/dogweather/1d17cc89fa8f69ff9e0f6fa90f364cb7


**Peak / delta RSS (Ruby 4.0.9)**

| Input size                      | current delta | lookahead delta |
| ------------------------------- | ------------- | --------------- |
|  100K chars (request 500 words) | **+4.8 MB**   | +0.1 MB         |
|  500K chars (request 200 words) | **+23.5 MB**  | **0 KB**        |

The original pattern forces the engine to consume the remainder of the string (`.*`), which produces both the large slowdown and the transient RSS spike. The lookahead version performs the same logical check without materializing that match.

Source and full output: https://gist.github.com/dogweather/40f182ef2ec7dd96e3fb08d97dac4df7


## Installation

Add this to your Rails application's `Gemfile`:

```ruby
gem "rails-truncate-words-fix"
```

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

The underlying fix replaces `#{sep}.*` with `(?=#{sep})` at the end of Rails' regular expression.

MIT licensed.
