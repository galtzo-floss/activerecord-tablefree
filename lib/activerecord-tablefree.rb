# legacy automatic require support
require "activerecord/tablefree"
require "version_gem"
require_relative "activerecord/tablefree/version"

ActiveRecord::Tablefree::NoDatabase::Version.class_eval do
  extend VersionGem::Basic
end
