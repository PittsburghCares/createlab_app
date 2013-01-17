class Project < ActiveRecord::Base
  has_many :pages
  has_one :project_image, :dependent => :destroy
  has_many :project_web_links, :dependent => :destroy
  has_and_belongs_to_many :users, :join_table => "users_projects"

  accepts_nested_attributes_for :project_image  
  accepts_nested_attributes_for :project_web_links, :reject_if => :all_blank, :allow_destroy => true

  validates_uniqueness_of :name
  validates_presence_of :name
  #validates_presence_of :description

  default_scope :conditions => ["projects.is_deleted = ?", false], :order => "projects.name ASC"
  named_scope :exclude_multi_project, :conditions => ["name != ?", "All"]
  named_scope :published, :conditions => {:is_published => true}
  named_scope :has_outreach, :conditions => {:has_outreach => true} 

  before_validation :check_link
  
  def check_link
    self.project_web_links.each do |web_link|
      unless web_link.link[/^https?:\/\//]
        web_link.link = "http://" + web_link.link
      end
    end
  end

  def web_link_list()
    self.project_web_links.map(&:link).join(", ")
  end

end
