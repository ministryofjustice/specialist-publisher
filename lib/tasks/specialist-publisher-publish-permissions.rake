namespace :permissions do
  desc "Give publish permssions to default user"
  task :grant => :environment do
    u = User.create(name: 'GDS Test Editor', uid: SecureRandom.uuid)
    u.permissions = ['gds_editor']
    u.save
  end
end
