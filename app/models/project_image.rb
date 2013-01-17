class ProjectImage < ActiveRecord::Base
  belongs_to :project

  has_attached_file  :image, 
                     :styles => {:crop => "120x78#", :medium => "250x175>", :large => "500x350#"},
                     :processors => [:cropper],
                     :whiny_thumbnails => true,
                     :url => "/projects/:id/:style/:filename",
                     :path => ":rails_root/public/projects/:id/:style/:filename"

  # Validations
  validates_attachment_content_type :image, 
                                    :content_type => ['image/jpeg', 'image/pjpeg', 'image/jpg', 'image/gif'],
                                    :message => 'Image must be a jpg or gif file type.'

  validates_attachment_size :image, :in => 0..3.megabyte
  validate :check_dimensions

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :reprocess_image, :if => :cropping?

  def check_dimensions
    if self.image && self.image.queued_for_write[:original] 
      dimensions = Paperclip::Geometry.from_file(self.image.queued_for_write[:original])  	
      self.errors.add(:image, " dimensions are too small. Please upload a larger image. Minimum width: 500px, minimum height: 350px") if dimensions.width < 500 && dimensions.height < 350
    end
  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def image_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(image.path(style))
  end

  private

    def reprocess_image
      image.reprocess!
    end
end
