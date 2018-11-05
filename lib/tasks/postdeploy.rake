desc 'Postdeploy task for setting up Heroku review apps'
task postdeploy: ['db:schema:load', 'db:seed'] do
end
