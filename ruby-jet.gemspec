Gem::Specification.new do |gem|
  gem.name        = 'ruby-jet'
  gem.version     = '0.14.0'
  gem.date        = '2017-06-02'
  gem.summary     = 'Jet API for Ruby'
  gem.description = 'Jet API service calls implemented in Ruby'
  gem.authors     = ['Jason Wells']
  gem.email       = ['flipstock@gmail.com', 'jason@iserve.com']
  gem.files       = Dir.glob('lib/**/*.rb') + %w[LICENSE README.md]
  gem.homepage    = 'https://github.com/jasonwells/ruby-jet'
  gem.license     = 'MIT'

  gem.add_runtime_dependency 'rest-client', '~> 2.0'
  gem.add_runtime_dependency 'oj', '>= 2.18'
end
