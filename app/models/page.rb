class Page < ActiveRecord::Base
  has_many :events, :dependent => :destroy
  belongs_to :project
  has_one :page_image, :dependent => :destroy
  has_many :page_web_links, :dependent => :destroy
  has_and_belongs_to_many :funders, :join_table => "pages_funders"

  accepts_nested_attributes_for :page_image
  accepts_nested_attributes_for :page_web_links, :reject_if => :all_blank, :allow_destroy => true

  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :project_id

  default_scope :conditions => {"is_deleted" => false}, :order => "pages.list_position ASC, pages.name ASC"
  named_scope :published, :conditions => {"pages.is_published" => true}
  named_scope :exclude_placeholder, :conditions => {"pages.is_placeholder" => false} 

  before_validation :check_link
  
  def check_link
    self.page_web_links.each do |web_link|
      unless web_link.link[/^https?:\/\//]
        web_link.link = "http://" + web_link.link
      end
    end
  end

  def web_link_list()
    self.page_web_links.map(&:link).join(", ")
  end

  def funder_list()
    self.funders.map(&:fullname).join(", ")
  end 
end
