# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
#if RAILS_ENV == 'development'
  # Create user roles
  roles = ["admin", "user"]
  roles.each {|role| Role.create :name => role}
  
  # Create default admin user
  #User.create :login => "admin", :email => 'outreach.createlab@gmail.com', :first_name => 'CREATE', :last_name => 'Lab', :password => 'foobar', :password_confirmation => 'foobar', :activated_at => "#{Time.now}"
  #user = User.find_by_login("admin")
  #user.roles << Role.find_by_name("admin")
  #user.save!
#end
