# Authentication
generate "devise:install"
generate "devise User"

if yes? 'Is postgres running?'
 rake 'db:create db:migrate'
end

# Git
git :init
git add: "."
git commit: "-a -m 'F1 #{APP_TYPE} Template'"

