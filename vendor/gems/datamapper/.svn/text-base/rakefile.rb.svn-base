#!/usr/bin/env ruby

require 'rake'
require 'spec/rake/spectask'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'

task :default => 'test'

desc "Run specifications"
Spec::Rake::SpecTask.new('test') do |t|
  t.spec_opts = [ '-rspec/spec_helper' ]
  t.spec_files = FileList[ENV['FILES'] || 'spec/*.rb']
end

desc "Run comparison with ActiveRecord"
task :perf do
  load 'performance.rb'
end

desc "Profile DataMapper"
task :profile do
  load 'profile_data_mapper.rb'
end

PACKAGE_VERSION = '0.1.1'

PACKAGE_FILES = FileList[
  'README',
  'CHANGELOG',
  'MIT-LICENSE',
  '*.rb',
  'lib/**/*.rb',
  'spec/**/*.{rb,yaml}'
].to_a

PROJECT = 'datamapper'

desc "Generate Documentation"
rd = Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title = "DataMapper -- An Object/Relational Mapper for Ruby"
  rdoc.options << '--line-numbers' << '--inline-source' << '--main' << 'README'
  rdoc.rdoc_files.include(PACKAGE_FILES.reject { |path| path =~ /^(spec|\w+\.rb)/ })
end

gem_spec = Gem::Specification.new do |s| 
  s.platform = Gem::Platform::RUBY 
  s.name = PROJECT 
  s.summary = "An Object/Relational Mapper for Ruby"
  s.description = "It's ActiveRecord, but Faster, Better, Simpler."
  s.version = PACKAGE_VERSION 
   
  s.authors = 'Sam Smoot'
  s.email = 'ssmoot@gmail.com'
  s.rubyforge_project = PROJECT 
  s.homepage = 'http://datamapper.org' 
   
  s.files = PACKAGE_FILES 
   
  s.require_path = 'lib'
  s.requirements << 'none'
  s.autorequire = 'data_mapper'

  s.has_rdoc = true 
  s.rdoc_options << '--line-numbers' << '--inline-source' << '--main' << 'README' 
  s.extra_rdoc_files = rd.rdoc_files.reject { |path| path =~ /\.rb$/ }.to_a 
end

Rake::GemPackageTask.new(gem_spec) do |p|
  p.gem_spec = gem_spec
  p.need_tar = true
  p.need_zip = true
end

desc "Publish to RubyForge"
task :rubyforge => [ :rdoc, :gem ] do
  Rake::SshDirPublisher.new(ENV['RUBYFORGE_USER'], "/var/www/gforge-projects/#{PROJECT}", 'doc').upload
end