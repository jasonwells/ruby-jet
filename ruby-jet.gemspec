Gem::Specification.new do |gem|
  gem.name        = 'ruby-jet'
  gem.version     = '0.0.4'
  gem.date        = '2015-09-29'
  gem.summary     = 'Jet API for Ruby'
  gem.description = 'Jet API service calls implemented in Ruby'
  gem.authors     = ['Jason Wells']
  gem.email       = 'flipstock@gmail.com'
  gem.files       = ['lib/jet.rb', 'lib/jet/client.rb', 'lib/jet/client/orders.rb']
  gem.homepage    = 'https://github.com/jasonwells/ruby-jet'
  gem.license     = 'MIT'

  gem.add_runtime_dependency 'rest-client', '~> 1.8'
  gem.add_runtime_dependency 'json', '~> 1.8'
end
