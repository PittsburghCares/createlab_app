class RemoveWebsiteFromProjects < ActiveRecord::Migration
  def self.up
    remove_column "projects", "website"
  end

  def self.down
    add_column "projects", "website", :text
  end
end
