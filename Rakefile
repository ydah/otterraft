# frozen_string_literal: true

require "bundler/gem_tasks"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc "steep check"
task :steep do
  sh "bundle exec steep check"
end

task default: %i[spec steep]
