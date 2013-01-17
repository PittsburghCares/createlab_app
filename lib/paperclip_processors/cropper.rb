module Paperclip
  class Cropper < Thumbnail
    def transformation_command
    	#would be nice to somehow specify to just do this for a specifc style, 
    	#no idea how and do not have time, so we do nasty hack...
      if crop_command && (super.join(' ').include?("120x") || super.join(' ').include?("60x"))
        crop_command + super.join(' ').sub(/ -crop \S+/, '').split(' ') # super returns an array like this: ["-resize", "100x", "-crop", "100x100+0+0", "+repage"]
      else
        super
      end
    end
    
    def crop_command
      target = @attachment.instance
      if target.cropping?
        ["-crop", "#{target.crop_w}x#{target.crop_h}+#{target.crop_x}+#{target.crop_y}"]
      end
    end
  end
end