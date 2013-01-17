class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.text :name
      t.references :page
      t.text :lab_contact
      t.text :partner_contact
      t.integer :pre_school,            :default => 0
      t.integer :elementary_school,     :default => 0
      t.integer :middle_school,         :default => 0
      t.integer :high_school,           :default => 0
      t.integer :adult,                 :default => 0
      t.datetime :start_date
      t.datetime :end_date
      t.text :comments
      t.boolean :is_published,          :default => false
      t.boolean :is_deleted,            :default => false
      t.references :user      
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
