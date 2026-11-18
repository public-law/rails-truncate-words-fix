# frozen_string_literal: true

require "minitest/autorun"
require_relative "../lib/rails_truncate_words_fix/patch"

class TruncateWordsTest < Minitest::Test
  def test_default_separator
    assert_equal "One two three...", "One two three four".truncate_words(3)
  end

  def test_string_separator
    assert_equal "one<br>two...", "one<br>two<br>three".truncate_words(2, separator: "<br>")
  end

  def test_regexp_separator
    assert_equal "one|two...", "one|two|three".truncate_words(2, separator: /\|/)
  end

  def test_custom_omission
    assert_equal "one two (more)", "one two three".truncate_words(2, omission: " (more)")
  end

  def test_no_truncation_returns_copy
    original = "one two"
    result = original.truncate_words(3)
    assert_equal original, result
    refute_same original, result
  end

  def test_trailing_separator_matches_rails_behavior
    assert_equal "one two...", "one two ".truncate_words(2)
  end

  def test_long_suffix
    result = ("one two " + "more " * 50_000).truncate_words(2)
    assert_equal "one two...", result
  end
end
