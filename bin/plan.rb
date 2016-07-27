#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.dirname(File.realpath(__FILE__)) + '/../lib')
require 'plan'

Plan::Runner.new(ARGV).run
