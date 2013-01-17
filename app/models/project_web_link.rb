class ProjectWebLink < ActiveRecord::Base
  belongs_to :project
  validates_presence_of :label
  validates_presence_of :link
end
