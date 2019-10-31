require 'simplecov'

if ENV['SIMPLECOV']
  SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
  SimpleCov.start { add_filter '/spec/' }
elsif ENV['TRAVIS'] && RUBY_VERSION.to_f >= 1.9
  require 'coveralls'
  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter,
  ]
  SimpleCov.start do
    track_files 'lib/**/*.rb'
    add_filter '/spec'
    add_filter '/vendor'
    add_filter '/.vendor'
  end

end

require_relative './helpers'
RSpec.configure do |c|
  c.include Helpers
end
