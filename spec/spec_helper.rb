$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'percona_ar'
require 'coveralls'
require 'simplecov'
require "codeclimate-test-reporter"

CodeClimate::TestReporter.start

Coveralls.wear!

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
      Coveralls::SimpleCov::Formatter
])

dir = File.join("..", "coverage")
SimpleCov.coverage_dir(dir)

$db_name = ENV["db"] || "myapp_test"
ActiveRecord::Base.establish_connection(
  adapter:  "mysql2",
  host:     ENV["db_host"] || "127.0.0.1",
  username: ENV["db_user"] || "travis",
  password: ENV["db_pass"] || "",
  database: $db_name
)
