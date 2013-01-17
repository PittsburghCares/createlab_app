class PageWebLink < ActiveRecord::Base
  belongs_to :page
  validates_presence_of :label
  validates_presence_of :link
end