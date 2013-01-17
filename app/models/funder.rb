class Funder < ActiveRecord::Base
  has_and_belongs_to_many :pages, :join_table => "pages_funders"
  validates_uniqueness_of :fullname
  validates_presence_of :fullname
  default_scope :order => "fullname ASC"
end
