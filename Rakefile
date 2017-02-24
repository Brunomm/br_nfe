require 'rake/testtask'
 
Rake::TestTask.new do |task|
  task.libs << %w(test lib)
  task.pattern = 'test/**/*_test.rb'
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r br_nfe.rb"
end
 
task :default => :test

namespace :test do
  desc "Test lib source"
  Rake::TestTask.new(:product) do |t|    
    t.libs << "test"
    t.pattern = 'test/br_nfe/product/**/*_test.rb'
    t.verbose = true    
  end

end

namespace :test do
  desc "Test lib source"
  Rake::TestTask.new(:service) do |t|    
    t.libs << "test"
    t.pattern = 'test/br_nfe/service/**/*_test.rb'
    t.verbose = true    
  end
end