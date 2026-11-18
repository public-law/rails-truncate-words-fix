# frozen_string_literal: true

module RailsTruncateWordsFix
  class Railtie < Rails::Railtie
    initializer "rails_truncate_words_fix.patch" do
      require "active_support/core_ext/string/filters"
      require "rails_truncate_words_fix/patch"
    end
  end
end
