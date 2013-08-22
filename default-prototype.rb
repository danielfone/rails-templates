# ruby '2.0.0'

# Disable tests
application 'config.generators.test_framework false'

# Read me
run 'rm README.rdoc'
file 'README.md', <<-README
## Template for rapid Rails prototypes
* Rails 4
* No tests / specs
* Bootstrap
README

# Bootstrap
gem 'twitter-bootstrap-rails'
generate "bootstrap:install"
generate "bootstrap:layout", "application", "fluid"

# Development only

file 'config/database.yml', <<-DB
development:
  adapter: sqlite3
  database: db/development.sqlite3
  pool: 5
  timeout: 5000
DB

run 'rm config/environments/production.rb config/environments/test.rb'

# Mute deprecations
initializer 'mute_deprecations.rb', <<-INIT
_muted_deprecations = %w(
)

_default_deprecation_behaviours = ActiveSupport::Deprecation.behavior
ActiveSupport::Deprecation.behavior = Proc.new do |msg, stack|
  next if _muted_deprecations.any? {|s| stack.first[s] }
  _default_deprecation_behaviours.each do |behaviour|
    behaviour.call msg, stack
  end
end
INIT

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

# Route
route "root to: 'application#root'"

# Git
git :init
git add: "."
git commit: "-a -m 'F1 Prototype'"

