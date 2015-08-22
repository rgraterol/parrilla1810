class UploadsController < ApplicationController
  respond_to :json
	require 'base64'

  def img
		data = params[:img]
		image_data = Base64.decode64(data['data:image/png;base64,'.length .. -1])

		File.open("#{Rails.root}/public/uploads/somefilename.png", 'wb') do |f|
			if f.write image_data
				render json: true
			else
				render json: false
			end
		end

	end



end
