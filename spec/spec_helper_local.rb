require 'simplecov'

if ENV['SIMPLECOV']
  SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
elsif ENV['TRAVIS'] && RUBY_VERSION.to_f >= 1.9
  require 'coveralls'
  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter,
  ]
end
SimpleCov.start { add_filter '/spec/' }

require_relative './helpers'
RSpec.configure do |c|
  c.include Helpers
end
