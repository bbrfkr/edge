require 'rake'
require 'rspec/core/rake_task'

if ENV['TEST_PROJECT'] != nil
  
  desc "Run serverspec to all hosts"
  task :spec => "spec:#{ ENV['TEST_PROJECT'] }"
  
  namespace :spec do
    desc "Run serverspec to #{ ENV['TEST_PROJECT'] }"
    RSpec::Core::RakeTask.new(ENV['TEST_PROJECT'].to_sym) do |t|
      t.pattern = "Projects/#{ ENV['TEST_PROJECT']}/spec/**/*_spec.rb"
    end
  end
end

