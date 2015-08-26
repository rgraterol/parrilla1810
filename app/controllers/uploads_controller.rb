class UploadsController < ApplicationController
  respond_to :json
	require 'base64'
	included Cipher

  def img
		email = ActionController::Parameters.new(email: params[:email]).permit(:email)[:email]
		user = User.find_by(email: email) || User.create(email: email, photo_count: 1)
		cipher = Cipher.new ["K", "D", "w", "X", "H", "3", "e", "1", "S", "B", "g", "a", "y", "v", "I", "6", "u", "W", "C", "0", "9", "b", "z", "T", "A", "q", "U", "4", "O", "o", "E", "N", "r", "n", "m", "d", "k", "x", "P", "t", "R", "s", "J", "L", "f", "h", "Z", "j", "Y", "5", "7", "l", "p", "c", "2", "8", "M", "V", "G", "i", "Q", "F"]
		file_name = cipher.encrypt(user.email + '_' + user.photo_count.to_s)
		data =  ActionController::Parameters.new(img: params[:img]).permit(:img)[:img]
		image_data = Base64.decode64(data['data:image/png;base64,'.length .. -1])

		directory_name = "#{Rails.root}/public/#{user.id}"
		Dir.mkdir(directory_name) unless File.exists?(directory_name)

		File.open("#{Rails.root}/public/#{user.id}/#{file_name}.png", 'wb') do |f|
			if f.write image_data
				current_photos = user.photo_count + 1
				user.update_column(:photo_count, current_photos)
				render json: "http://sshelium.chickenkiller.com:3000/#{user.id}/#{file_name}.png".to_json
				return
			else
				render json: 'false'.to_json
				return
			end
		end
	end



end
