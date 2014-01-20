source_paths << File.dirname(__FILE__)

inject_into_file 'Gemfile', after: "source 'https://rubygems.org'\n" do
  "ruby File.read '.ruby-version'\n\n"
end

file '.ruby-version', '2.1.0'

gem 'devise'
gem 'twitter-bootstrap-rails'
gem 'will_paginate-bootstrap'
gem 'will_paginate'

gem_group :production do
  gem 'thin'
  gem 'rails_12factor'
end

#run 'bundle install'

# Disable strong params
application 'config.action_controller.permit_all_parameters = true'
application 'config.action_controller.action_on_unpermitted_parameters = :raise'

# Read me
run 'rm README.rdoc'
file 'README.md', <<-README
## Template for rapid Rails prototypes
* Rails 4
* No tests / specs
* Bootstrap
README

# Bootstrap
generate "bootstrap:install", "static"
generate "bootstrap:layout", "application", "fluid"
copy_file 'prototype/application.html.erb', 'app/views/layouts/application.html.erb'
copy_file 'prototype/bootstrap_and_overrides.css', 'app/assets/stylesheets/bootstrap_and_overrides.css'

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

# Authentication
generate "devise:install"
generate "devise User"

# Remove turbolinks
gsub_file 'Gemfile', <<-TURBO, ''
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
TURBO
gsub_file 'app/assets/javascripts/application.js', "//= require turbolinks\n", ''

# Clean database.yml
gsub_file 'config/database.yml', /  username: \S+\n  password:\n/, ''

if yes? 'Is postgres running?'
 rake 'db:create db:migrate'
end

route 'root to: "application#show"'

# Git
git :init
git add: "."
git commit: "-a -m 'F1 Prototype'"

