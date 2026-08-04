# kettle-jem:freeze
# To retain chunks of comments & code during activerecord-tablefree templating:
# Wrap custom sections with freeze markers (e.g., as above and below this comment chunk).
# activerecord-tablefree will then preserve content between those markers across template runs.
# kettle-jem:unfreeze

# Minimum coverage thresholds are set by kettle-soup-cover.
# They are controlled by ENV variables loaded by `mise` from `mise.toml`
# (with optional machine-local overrides in `.env.local`).
# If the values for minimum coverage need to change, they should be changed both there,
#   and in 2 places in .github/workflows/coverage.yml.
SimpleCov.configure do
  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("4.0")
    # ActiveRecord 5.2 cannot execute its database-backed compatibility specs
    # on Ruby 4, and the implementation intentionally rejects other engines.
    # The legacy path is covered by the Ruby 2.4 appraisal under `act`.
    add_filter "lib/activerecord/tablefree"
  end

  if SimpleCov::Configuration.method_defined?(:cover)
    cover "lib/**/*.rb", "lib/**/*.rake", "exe/*.rb"
  else
    track_files "{lib/**/*.rb,lib/**/*.rake,exe/*.rb}"
  end
end
