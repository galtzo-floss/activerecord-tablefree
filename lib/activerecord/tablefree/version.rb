# frozen_string_literal: true

module ActiveRecord
  module Tablefree
    module NoDatabase
      # Version namespace for this gem.
      module Version
        # Current gem version.
        VERSION = "3.1.8"
      end
      # Current gem version exposed at the traditional constant location.
      VERSION = Version::VERSION # Traditional Constant Location
    end
  end
end
