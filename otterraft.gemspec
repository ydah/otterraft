# frozen_string_literal: true

require_relative "lib/otterraft/version"

Gem::Specification.new do |spec|
  spec.name = "otterraft"
  spec.version = Otterraft::VERSION
  spec.authors = ["Yudai TAKADA"]
  spec.email = ["t.yudai92@gmail.com"]

  spec.summary = "Simple YAML Frontmatter Parser"
  spec.homepage = "https://github.com/ydah/otterraft"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/releases"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
