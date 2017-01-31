# coding: utf-8
 
Gem::Specification.new do |spec|
  spec.name          = "blade-theme"
  spec.version       = "1.2.1"
  spec.authors       = ["Mateus Medeiros"]
  spec.email         = ["mateus.sousamedeiros@gmail.com"]
 
  spec.summary       = %q{A simple Jekyll blog theme.}
  spec.description   = "A simple Jekyll blog theme, perfect for developers."
  spec.homepage      = "https://mateussmedeiros.github.io/blade-theme/"
  spec.license       = "MIT"
 
  spec.add_runtime_dependency "jekyll", "~> 3.3"
  spec.add_runtime_dependency "jekyll-feed", "~> 0.6"
  spec.add_runtime_dependency 'jekyll-seo-tag'
  spec.add_runtime_dependency "jekyll-sitemap"
  spec.add_runtime_dependency "jekyll-paginate", "~> 1.1"
 
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "sass", "~> 3.4", ">= 3.4.19"

end