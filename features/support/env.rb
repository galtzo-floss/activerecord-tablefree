# require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn "Run `bundle install` to install missing gems"
  exit e.status_code
end

require "aruba/cucumber"
require "capybara/cucumber"

Before do
  @aruba_timeout_seconds = 120
end
