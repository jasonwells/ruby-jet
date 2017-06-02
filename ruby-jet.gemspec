Gem::Specification.new do |gem|
  gem.name        = 'ruby-jet'
  gem.version     = '0.9.0'
  gem.date        = '2016-11-03'
  gem.summary     = 'Jet API for Ruby'
  gem.description = 'Jet API service calls implemented in Ruby'
  gem.authors     = ['Jason Wells','Mike Ball']
  gem.email       = ['flipstock@gmail.com', 'jason@iserveproducts.com']
  gem.files       = Dir.glob('lib/**/*.rb') + %w(LICENSE README.md)
  gem.homepage    = 'https://github.com/jasonwells/ruby-jet'
  gem.license     = 'MIT'

  gem.add_runtime_dependency 'rest-client', '~> 2.0'
  gem.add_runtime_dependency 'oj', '~> 3.0'
end
