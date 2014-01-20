### Gem config

file '.ruby-version', '2.1.0'

inject_into_file 'Gemfile', after: "source 'https://rubygems.org'\n" do
  "ruby File.read '.ruby-version'\n\n"
end

gem 'devise'
gem 'bootstrap-sass'
gem 'will_paginate-bootstrap'

gem_group :production do
  gem 'rails_12factor'
  gem 'unicorn'
end

copy_file 'shared/Procfile', 'Procfile'
copy_file 'shared/unicorn.rb', 'config/unicorn.rb'
copy_file 'shared/_errors.html.erb', 'app/views/application/_errors.html.erb'
copy_file "#{APP_TYPE}/README.md"
run 'rm README.rdoc'

# Secret key fix
environment "config.secret_key_base = 'x' * 30", env: ['test', 'development']
environment "config.secret_key_base = ENV['SECRET_KEY_BASE']", env: 'production'
run 'rm config/initializers/secret_token.rb'

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

# Remove turbolinks
gsub_file 'Gemfile', <<-TURBO, ''
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
TURBO
gsub_file 'app/assets/javascripts/application.js', "//= require turbolinks\n", ''

