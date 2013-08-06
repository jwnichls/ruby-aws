Gem::Specification.new do |s|
  s.name        = 'ruby-aws'
  s.version     = '1.6.1'
  s.date        = '2013-08-06'
  s.summary     = "Ruby-aws"
  s.description = "Modified from http://rubygems.org/gems/ruby-aws"
  s.authors     = ["Peter Kinnaird"]
  s.email       = 'peter.kinnaird@gmail.com'
  s.files       = Dir.glob("{bin,lib}/**/*")
  s.add_dependency('highline')
  s.add_dependency('nokogiri')
  s.homepage    = 'https://github.com/peterkinnaird/ruby-aws'
  s.license       = 'MIT'
end