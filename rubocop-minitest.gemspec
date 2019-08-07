lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rubocop/minitest/version"

Gem::Specification.new do |spec|
  spec.name          = "rubocop-minitest"
  spec.version       = Rubocop::Minitest::VERSION
  spec.authors       = ['Bozhidar Batsov', 'Jonas Arvidsson', 'Koichi ITO']

  spec.summary       = 'This namespace is reserved by RuboCop HQ.'
  spec.description   = 'This namespace is reserved by RuboCop HQ.'
  spec.license       = 'MIT'

  spec.metadata["homepage_uri"] =  'https://github.com/rubocop-hq/rubocop-minitest'
  spec.metadata["source_code_uri"] = 'https://github.com/rubocop-hq/rubocop-minitest'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rubocop", ">= 0.74"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.11"
end
