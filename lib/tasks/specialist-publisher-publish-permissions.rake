namespace :permissions do
  desc "Give publish permssions to default user"
  task :grant => :environment do
    u = User.first
    u.permissions << 'gds_editor'
    u.save!
  end
end
