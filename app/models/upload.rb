class Upload < ActiveRecord::Base
	mount_uploader :img, ImageUploader

end
