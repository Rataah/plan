require 'rubocop/rake_task'
require 'rspec/core/rake_task'

desc 'Run rubocop'
task :rubocop do
  RuboCop::RakeTask.new
end

desc 'Run rspec'
RSpec::Core::RakeTask.new(:spec)
task default: [:spec, :rubocop]
