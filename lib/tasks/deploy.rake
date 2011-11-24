desc 'Precompile assets & then deploy to Heroku'
task :deploy do
  result = system('bundle exec rake assets:precompile')
  
  unless result
    puts "assets:precompile may have failed: #{$?}"
    return
  end
  
  `git commit public/assets -m "new assets for deploy"`
  `git push heroku`
end