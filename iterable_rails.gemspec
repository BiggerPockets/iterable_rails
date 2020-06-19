lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "iterable_rails/version"

Gem::Specification.new do |spec|
  spec.name          = "iterable_rails"
  spec.version       = IterableRails::VERSION
  spec.authors       = ["Lewis Buckley"]
  spec.email         = ["lewis@lewisbuckley.co.uk"]

  spec.summary       = "Provides ActionMailer compatible delivery method for Iterable"
  spec.description   = "Provides ActionMailer compatible delivery method for Iterable"
  spec.homepage      = "https://www.github.com/biggerpockets/iterable_rails"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://www.github.com/biggerpockets/iterable_rails"
  spec.metadata["changelog_uri"] = "https://www.github.com/biggerpockets/iterable_rails/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency("actionmailer", ">= 3.0.0")

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 2"
  spec.add_development_dependency "byebug"

  spec.add_dependency "iterable-api-client", "~> 0.3"
end
