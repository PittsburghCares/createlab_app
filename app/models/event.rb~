class Event < ActiveRecord::Base
  belongs_to :page
  has_and_belongs_to_many :users, :join_table => "users_events"

  acts_as_taggable_on :organization, :location, :arena, :geographic_scope,
  :connection_dialog, :affiliation, :tag, :web_link

  default_scope :conditions => {:is_deleted => false}, :order => "events.created_at DESC"

  #validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :page_id

  named_scope :published, :conditions => {:is_published => true}

  IGNORE_IN_COUNTS = ["Independent", "CREATE Lab"]

  #def self.find_tags_like_query(query, contexts, order, limit)
  #	ActiveRecord::Base.connection.execute(
  #		"SELECT DISTINCT tags.name FROM tags
  #		INNER JOIN taggings ON taggings.tag_id = tags.id
  #		WHERE #{contexts} AND tags.name LIKE '%#{query}%'
  #		ORDER BY tags.name #{order}
  #		LIMIT #{limit}"
  #	).map {|t| t["name"] }
  #end

  def self.find_tags_like_query(query, contexts, order, limit)
    ActiveRecord::Base.connection.execute(sanitize_sql_array(["SELECT DISTINCT tags.name FROM tags INNER JOIN taggings ON taggings.tag_id = tags.id WHERE #{contexts} AND tags.name LIKE ? ORDER BY tags.name #{order} LIMIT #{limit}", "%#{query}%"])
    ).map {|t| t["name"] }
  end

  def self.find_tags(query, taggings_contexts, order = "ASC", limit = -1)
    contexts = "("
    taggings_contexts.each { |context| contexts += "taggings.context = '#{context}' OR " }
    contexts.chomp!(" OR ")
    contexts += ")"
    return find_tags_like_query(query, contexts, order, limit)
  end

  def total_participants
    pre_school + elementary_school + middle_school + high_school + adult + mentors
  end

  def organization=(value)
    value.each do |v|
      self.organization_list << v unless v.blank?
    end
  end

  def location=(value)
    value.each do |v|
      self.location_list << v unless v.blank?
    end
  end

  def arena=(value)
    value.each do |v|
      self.arena_list << v unless v.blank?
    end
  end

  def geographic_scope=(value)
    value.each do |v|
      self.geographic_scope_list << v unless v.blank?
    end
  end

  def connection_dialog=(value)
    value.each do |v|
      self.connection_dialog_list << v unless v.blank?
    end
  end

  def affiliation=(value)
    value.each do |v|
      self.affiliation_list << v unless v.blank?
    end
  end

  def tag=(value)
    value.each do |v|
      self.tag_list << v unless v.blank?
    end
  end

  def web_link()
    value.each do |v|
      self.web_link_list << v unless v.blank?
    end
  end
end
