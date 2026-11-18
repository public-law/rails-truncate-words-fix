# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "rails-truncate-words-fix"
  spec.version = "0.1.0"
  spec.authors = ["Robert Shecter"]
  spec.summary = "Avoid unnecessary suffix matching in Active Support's String#truncate_words"
  spec.description = "A Rails Railtie applying the optimization from rails/rails#59848."
  spec.homepage = "https://github.com/public-law/rails-truncate-words-fix"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.4"
  spec.files = Dir["lib/**/*.rb", "README.md", "LICENSE"]
  spec.require_paths = ["lib"]

  spec.add_dependency "railties", ">= 7.2", "< 9"
  spec.metadata["source_uri"] = spec.homepage
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"
end
