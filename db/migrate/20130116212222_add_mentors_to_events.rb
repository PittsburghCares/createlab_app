class AddMentorsToEvents < ActiveRecord::Migration
  def self.up
    add_column "events", "mentors", :integer, :default=>0
  end

  def self.down
    remove_column "events", "mentors"
  end
end
