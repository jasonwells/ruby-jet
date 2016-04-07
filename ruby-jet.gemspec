Gem::Specification.new do |gem|
  gem.name        = 'ruby-jet'
  gem.version     = '0.5.0'
  gem.date        = '2016-04-06'
  gem.summary     = 'Jet API for Ruby'
  gem.description = 'Jet API service calls implemented in Ruby'
  gem.authors     = ['Jason Wells']
  gem.email       = ['flipstock@gmail.com', 'jason@iserveproducts.com']
  gem.files       = Dir.glob('lib/**/*.rb') + %w(LICENSE README.md)
  gem.homepage    = 'https://github.com/jasonwells/ruby-jet'
  gem.license     = 'MIT'

  gem.add_runtime_dependency 'rest-client', '~> 1.8'
  gem.add_runtime_dependency 'json', '~> 1.8'
end
