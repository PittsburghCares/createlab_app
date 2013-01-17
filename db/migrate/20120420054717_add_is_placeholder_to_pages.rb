class AddIsPlaceholderToPages < ActiveRecord::Migration
  def self.up
    add_column "pages", "is_placeholder", :boolean, :default => false
  end

  def self.down
    remove_column "pages", "is_placeholder"
  end
end
