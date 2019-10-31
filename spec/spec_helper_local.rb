require 'simplecov'
require_relative './helpers'

if ENV['SIMPLECOV']
  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
  ]
  SimpleCov.start { add_filter '/spec/' }
elsif ENV['TRAVIS'] && RUBY_VERSION.to_f >= 1.9
  require 'coveralls'
  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter,
  ]
  Coveralls.wear! { add_filter '/spec/' }
end

RSpec.configure do |c|
  c.include Helpers
end
