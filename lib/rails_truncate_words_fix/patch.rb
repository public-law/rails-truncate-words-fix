# frozen_string_literal: true

module RailsTruncateWordsFix
  module Patch
    def truncate_words(words_count, options = {})
      sep = options[:separator] || /\s+/
      sep = Regexp.escape(sep.to_s) unless Regexp === sep

      if self =~ /\A((?>.+?#{sep}){#{words_count - 1}}.+?)(?=#{sep})/m
        $1 + (options[:omission] || "...")
      else
        dup
      end
    end
  end
end

String.prepend(RailsTruncateWordsFix::Patch) unless String.ancestors.include?(RailsTruncateWordsFix::Patch)
