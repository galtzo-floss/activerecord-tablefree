Given(/^I delete all migrations$/) do
  steps %(
    When I successfully run `bash -c 'rm db/migrate/*.rb'`
  )
end

Given(/^I update my new user model to be tablefree$/) do
  in_current_dir do
    file_name = "app/models/user.rb"
    content = File.read(file_name)
    if framework_version < "3.0"
      content = "require 'activerecord-tablefree'\n" + content
    end

    content.gsub!(/^(class .* < ActiveRecord::Base)$/, "\\1\n" + <<-TABLELESS)
  has_no_table
  column :id, :integer
  column :name, :string

    TABLELESS
    File.open(file_name, "w") { |f| f << content }
  end
end

Given(/^I update my users controller to render instead of redirect$/) do
  in_current_dir do
    transform_file("app/controllers/users_controller.rb") do |content|
      # #Changes in #create method
      content.gsub!(/@user = User.new\((.*?)\)/,
        '@user = User.new(\1); @user.id = 1')
      content.gsub!("if @user.save",
        "if @user.valid?")
      content.gsub!(/redirect_to([( ])@user, .*?(\)| \}|$)/,
        "render\\1:action => 'show'\\2")
    end
  end
end
