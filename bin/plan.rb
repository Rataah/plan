$LOAD_PATH.unshift(File.join(__dir__, '/../lib'))
require 'plan'

Plan::Runner.new(ARGV).run
