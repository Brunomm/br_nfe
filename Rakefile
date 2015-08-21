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