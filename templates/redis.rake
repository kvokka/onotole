namespace :redis do
  desc "Clears Rails cache"
  task :flushall => :environment do
    Redis.new.flushall
  end
end
