# legacy automatic require support
require "activerecord/tablefree"
require "version_gem"
require_relative "activerecord/tablefree/version"

ActiveRecord::Tablefree::ActsMethods::Version.class_eval do
  extend VersionGem::Basic
end

ActiveRecord::Tablefree::Version.class_eval do
  extend VersionGem::Basic
end
