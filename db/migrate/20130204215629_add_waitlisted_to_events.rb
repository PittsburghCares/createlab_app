class AddWaitlistedToEvents < ActiveRecord::Migration
  def self.up
    add_column "events", "waitlisted", :integer, :default=>0
  end

  def self.down
    remove_column "events", "waitlisted"
  end
end
