
$gemspec = Gem::Specification.new do |s|

  s.name = 'rufus-h'
  s.version = '0.1.0'
  s.authors = [ 'John Mettraux' ]
  s.email = 'jmettraux@gmail.com'
  s.homepage = 'http://rufus.rubyforge.org/'
  s.platform = Gem::Platform::RUBY
  s.summary = 'turning Ruby object into JSON serializable structures and back'

  s.require_path = 'lib'
  s.test_file = 'test/test.rb'
  s.has_rdoc = true
  s.extra_rdoc_files = %w{ README.txt CHANGELOG.txt CREDITS.txt }
  s.rubyforge_project = 'rufus'

  #%w{ ffi }.each do |d|
  #  s.requirements << d
  #  s.add_dependency(d)
  #end

  files = [ '{lib,test}/**/*' ].map { |p| Dir[p] }.flatten
  s.files = files.to_a
end

