# ruby '2.0.0'

# Readme
# heroku
# rspec - coverage

# Read me
run 'rm README.rdoc'
file 'README.md', <<-README
## Template
Build Status
Dependency Status
Code Climate

README

# database.yml
dbname = ask 'Database name: '
file 'config/database.yml', %Q[
  development: &development
    adapter: postgresql
    database: #{dbname}

  test: &test
    adapter: postgresql
    database: #{dbname}-test

  production: *development
]

# Bootstrap
gem 'twitter-bootstrap-rails'

# Templates
file 'app/views/shared/_errors.html.erb', <<-ERRORS
<% if object.errors.any? %>
  <div class="alert alert-error">
    <a class="close" data-dismiss="alert">&#215;</a>
    <ul>
      <% object.errors.full_messages.each do |msg| %>
        <%= content_tag :li, msg %>
      <% end %>
    </ul>
  </div>
<% end %>
ERRORS

# Secret key fix
environment "config.secret_key_base = 'x' * 30", env: ['test', 'development']
environment "config.secret_key_base = ENV['SECRET_KEY_BASE']", env: 'production'
run 'rm config/initializers/secret_token.rb'

# Unicorn setup
gem 'unicorn'
file 'config/unicorn.rb', <<-UNICORN
worker_processes Integer(ENV['WEB_CONCURRENCY'] || 3)
timeout Integer(ENV['WEB_TIMEOUT'] || 20)
preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end  

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to sent QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
UNICORN

# Heroku
gem 'rails_12factor'
file 'Procfile', "web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb\n"

# rspec setup
gem_group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

gem_group :test do
  gem 'capybara'
  gem 'simplecov'
end

application %q[
    config.generators do |g|
      g.factory_girl suffix: 'factory'
    end
]

run 'bundle'

# POST BUNDLE
generate 'rspec:install'
generate "bootstrap:install", "static"
generate "bootstrap:layout", "application", "fluid" 

# Git
git :init
git add: "."
git commit: "-a -m 'F1 Production Template'"
