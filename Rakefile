
require 'rubygems'

require 'rake'
require 'rake/clean'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'


#$: << 'lib'
load 'rufus-h.gemspec'

RUFUS_H_VERSION = '0.1.0'

#
# tasks


CLEAN.include('pkg', 'html', 'rdoc')

task :default => [ :clean, :repackage ]


#
# SPECING

task :spec do
  load File.dirname(__FILE__) + '/spec/spec.rb'
end


#
# PACKAGING

Rake::GemPackageTask.new($gemspec) do |pkg|
  #pkg.need_tar = true
end

Rake::PackageTask.new('rufus-h', RUFUS_H_VERSION) do |pkg|

  pkg.need_zip = true
  pkg.package_files = FileList[
    'Rakefile',
    '*.txt',
    'lib/**/*',
    'test/**/*'
  ].to_a
  #pkg.package_files.delete("MISC.txt")
  class << pkg
    def package_name
      "#{@name}-#{@version}-src"
    end
  end
end


#
# DOCUMENTATION

#ALLISON=`allison --path`
ALLISON='/Library/Ruby/Gems/1.8/gems/allison-2.0.3/lib/allison.rb'

Rake::RDocTask.new do |rd|

  rd.main = 'README.txt'

  rd.rdoc_dir = 'html/rufus-h'

  rd.rdoc_files.include(
    'README.txt',
    'CHANGELOG.txt',
    'LICENSE.txt',
    'CREDITS.txt',
    'lib/**/*.rb')

  rd.title = 'rufus-h rdoc'

  rd.options << '-N' # line numbers
  rd.options << '-S' # inline source

  rd.template = ALLISON if File.exist?(ALLISON)
end


#
# WEBSITE

task :upload_website => [ :clean, :rdoc ] do

  account = 'jmettraux@rubyforge.org'
  webdir = '/var/www/gforge-projects/rufus'

  sh "rsync -azv -e ssh html/rufus-h #{account}:#{webdir}/"
end

