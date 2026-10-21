require "anonymous_loader"
require "activerecord-tablefree"
RSpec.describe ActiveRecord::Tablefree do
  it "has a version number" do
    expect(ActiveRecord::Tablefree::VERSION).not_to be_nil
  end

  it "executes the version file for coverage without redefining constants" do
    dir = File.expand_path("../../../lib/activerecord/tablefree", __dir__)
    paths = %w[version.rb version_gem.rb].map { |file| File.join(dir, file) }.select { |path| File.file?(path) }
    anonymous_namespace = AnonymousLoader.load(files: paths)

    expect(anonymous_namespace::ActiveRecord::Tablefree::VERSION).to eq(described_class::VERSION)
  end
end
