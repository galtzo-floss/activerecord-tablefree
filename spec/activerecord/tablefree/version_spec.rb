require "anonymous_loader"
RSpec.describe ActiveRecord::Tablefree do
  it "has a version number" do
    expect(ActiveRecord::Tablefree::VERSION).not_to be_nil
  end

  it "executes the version file for coverage without redefining constants" do
    paths = [
      File.expand_path("../../../lib/activerecord/tablefree/version.rb", __dir__),
      File.expand_path("../../../lib/activerecord/tablefree/version_gem.rb", __dir__)
    ].select { |path| File.file?(path) }
    anonymous_namespace = AnonymousLoader.load(files: paths)

    expect(anonymous_namespace::ActiveRecord::Tablefree::ActsMethods::Version::VERSION).to eq(described_class::VERSION)
  end
end
