$LOAD_PATH << File.expand_path("../src", __FILE__)

Gem::Specification.new do |s|
  s.name = 'wordcuta'
  s.version = '0.0.1'
  s.authors = ['Vee Satayamas']
  s.email = ['5ssgdxltv@relay.firefox.com']
  s.licenses = ['LGPL-3.0']
  s.description = "A word segmentation tools for ASEAN languages wrapper for Ruby"
  s.homepage = "https://github.com/veer66/wordcuta"
  s.require_paths = ["src"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.3.0")
  s.summary = "A word segmentation tools for ASEAN languages wrapper for Ruby"
  s.files = Dir.glob("src/*") + %w(README.md LICENSE) + Dir.glob("data/*")
  s.require_paths = ['.']
end
