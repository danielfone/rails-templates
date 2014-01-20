APP_TYPE='production'

source_paths << File.dirname(__FILE__)
eval File.read File.join File.dirname(__FILE__), '_shared.rb'

application 'config.action_controller.action_on_unpermitted_parameters = :raise'

# rspec setup
gem_group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

gem_group :test do
  gem 'capybara'
  gem 'simplecov'
end

run 'bundle'

eval File.read File.join File.dirname(__FILE__), '_post_bundle.rb'

generate 'rspec:install'

inject_into_file 'spec/spec_helper.rb', %Q[\n\nrequire 'simplecov'\nSimpleCov.start 'rails'\n\n], after: %q[ENV["RAILS_ENV"] ||= 'test']
