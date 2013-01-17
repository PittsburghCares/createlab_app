class CreateProjectImages < ActiveRecord::Migration
  def self.up
    create_table :project_images do |t|
      #page specific fields
      t.references :project

      #paperclip specific fields
      t.string  :image_file_name
      t.string  :image_content_type
      t.integer :image_file_size

      #generic db fields
      t.timestamps
    end
  end
  
  def self.down
    drop_table :project_stories
  end
end
