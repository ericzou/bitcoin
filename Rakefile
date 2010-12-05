require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "bitcoin"
  gem.homepage = "http://github.com/requnix/bitcoin"
  gem.license = "MIT"
  gem.summary = %Q{Ruby library for communicating with a Bitcoin client}
  gem.description = %Q{The Bitcoin RubyGem intends to simplify the process of communicating with and managing a BitCoin client on the same server by issuing commands to it via the bitcoind CLI. It will also include basic account management and transaction feedback.}
  gem.email = "michael.prins@me.com"
  gem.author = "Michael Prins"
  gem.requirements << "An instance of the bitcoin client running where the gem will be loaded"
  
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  gem.add_runtime_dependency 'json'
  
  gem.add_development_dependency 'rspec', '~> 2.2.0'
  gem.add_development_dependency 'jeweler', '~> 1.5.1'
  gem.add_development_dependency 'simplecov', '>= 0.3.5'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = FileList['spec/**/*_spec.rb']
  t.rspec_opts = ['--format nested', '--color']
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""
  
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "Bitcoin Gem #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
