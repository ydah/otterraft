# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "rake", "~> 13.0"
gem "rspec", "~> 3.0"

# Recent steep requires Ruby >= 3.0.0.
# Then skip install on some CI jobs.
if !ENV['GITHUB_ACTION'] || ENV['INSTALL_STEEP'] == 'true'
  # Ruby 4.1+ no longer ships tsort as a default gem; rbs/steep require it.
  gem "tsort"
  gem "rbs", "~> 3.4"
  gem "steep", "~> 1.6"
end
