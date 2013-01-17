class AddHasOutreachToPages < ActiveRecord::Migration
  def self.up
    add_column "pages", "has_outreach", :boolean, :default => true
    add_column "pages", "status", :text
  end

  def self.down
    remove_column "pages", "has_outreach"
    remove_column "pages", "status"
  end
end
