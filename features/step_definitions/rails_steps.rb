Given(/^I generate a new rails application$/) do
  steps %(
    When I successfully run `bundle exec #{new_application_command(APP_NAME)}`
    And I cd to "#{APP_NAME}"
    And I turn off class caching
    And I fix the application.rb for 3.0.12
    And I write to "Gemfile" with:
      """
      source "http://rubygems.org"
      gem "rails", "#{framework_version}"
      gem "sqlite3"
      gem "capybara"
      gem "gherkin"
      """
    And I configure the application to use "activerecord-tablefree" from this project
    And I reset Bundler environment variable
    And I successfully run `bundle install --local`
  )
end

Given "I fix the application.rb for 3.0.12" do
  # #See https://github.com/rails/rails/issues/9619
  in_current_dir do
    File.open("config/application.rb", "a") do |f|
      f << "ActionController::Base.config.relative_url_root = ''"
    end
  end
end

Given(/^I run a "(.*?)" generator to generate a "(.*?)" scaffold with "(.*?)"$/) do |generator_name, model_name, attributes|
  step %(I successfully run `bundle exec #{generator_command} #{generator_name} #{model_name} #{attributes}`)
end

Given(/^I start the rails application$/) do
  in_current_dir do
    require "./config/environment"
    require "capybara/rails"
  end
end

Given(/^I reload my application$/) do
  Rails::Application.reload!
end

When(/I turn off class caching/) do
  in_current_dir do
    file = "config/environments/test.rb"
    config = IO.read(file)
    config.gsub!(/^\s*config.cache_classes.*$/,
      "config.cache_classes = false")
    File.write(file, config)
  end
end

Given(/^I update my application to use Bundler$/) do
  if framework_version?("2")
    boot_config_template = File.read("features/support/fixtures/boot_config.txt")
    preinitializer_template = File.read("features/support/fixtures/preinitializer.txt")
    gemfile_template = File.read("features/support/fixtures/gemfile.txt")
    in_current_dir do
      content = File.read("config/boot.rb").sub("Rails.boot!", boot_config_template)
      File.write("config/boot.rb", content)
      File.write("config/preinitializer.rb", preinitializer_template)
      File.write("Gemfile", gemfile_template.sub("RAILS_VERSION", framework_version))
    end
  end
end

Then(/^the file at "([^"]*)" should be the same as "([^"]*)"$/) do |web_file, path|
  expected = IO.binread(path)
  actual = if web_file =~ %r{^https?://}
    Net::HTTP.get(URI.parse(web_file))
  else
    visit(web_file)
    page.source
  end
  actual.should == expected
end

When(/^I configure the application to use "([^"]+)" from this project$/) do |name|
  append_to_gemfile "gem '#{name}', :path => '#{PROJECT_ROOT}'"
  steps %(And I run `bundle install --local`)
end

When(/^I configure the application to use "([^"]+)"$/) do |gem_name|
  append_to_gemfile "gem '#{gem_name}'"
end

When(/^I append gems from Appraisal Gemfile$/) do
  File.read(ENV["BUNDLE_GEMFILE"]).split("\n").each do |line|
    append_to_gemfile line.strip if line =~ /^gem "(?!rails|appraisal)/
  end
end

When(/^I comment out the gem "(.*?)" from the Gemfile$/) do |gemname|
  comment_out_gem_in_gemfile gemname
end

Then(/^the result of "(.*?)" should be the same as "(.*?)"$/) do |rails_expr, path|
  expected = IO.binread(path)
  actual = eval rails_expr.to_s
  actual.should == expected
end

module FileHelpers
  def append_to(path, contents)
    in_current_dir do
      File.open(path, "a") do |file|
        file.puts
        file.puts contents
      end
    end
  end

  def append_to_gemfile(contents)
    append_to("Gemfile", contents)
  end

  def comment_out_gem_in_gemfile(gemname)
    in_current_dir do
      gemfile = File.read("Gemfile")
      gemfile.sub!(/^(\s*)(gem\s*['"]#{gemname})/, '\\1# \\2')
      File.write("Gemfile", gemfile)
    end
  end

  def transform_file(filename)
    if File.exist?(filename)
      content = File.read(filename)
      File.open(filename, "w") do |f|
        content = yield(content)
        f.write(content)
      end
    end
  end
end

World(FileHelpers)
