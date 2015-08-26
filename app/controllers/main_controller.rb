class MainController < ApplicationController
	before_action :check_participante_registrado, only: :registrar_participante
	included Cipher

	def index
	end

	def load_main_frame
		render partial: 'main'
	end

	def registrar_participante
		@participante = Participante.new(participante_params)
		respond_to do |format|
			if @participante.save
				format.html { redirect_to main_felicidades_path(sc: @participante.id) and return }
			else
				format.html {redirect_to root_path and return }
			end
		end
	end

	def felicidades
		participante = Participante.find_by(id:  ActionController::Parameters.new(sc: params[:sc]).permit(:sc)[:sc])
		user = User.find_by_email(participante.email) if participante.present?
		if user.present?
			cipher = Cipher.new ["K", "D", "w", "X", "H", "3", "e", "1", "S", "B", "g", "a", "y", "v", "I", "6", "u", "W", "C", "0", "9", "b", "z", "T", "A", "q", "U", "4", "O", "o", "E", "N", "r", "n", "m", "d", "k", "x", "P", "t", "R", "s", "J", "L", "f", "h", "Z", "j", "Y", "5", "7", "l", "p", "c", "2", "8", "M", "V", "G", "i", "Q", "F"]
			@img = cipher.encrypt(user.email + '_' + (user.photo_count - 1 ).to_s)
			@id = participante.id
		else
			redirect_to root_url and return
		end
	end


	def galeria
		cipher = Cipher.new ["K", "D", "w", "X", "H", "3", "e", "1", "S", "B", "g", "a", "y", "v", "I", "6", "u", "W", "C", "0", "9", "b", "z", "T", "A", "q", "U", "4", "O", "o", "E", "N", "r", "n", "m", "d", "k", "x", "P", "t", "R", "s", "J", "L", "f", "h", "Z", "j", "Y", "5", "7", "l", "p", "c", "2", "8", "M", "V", "G", "i", "Q", "F"]
		last = User.last
		if last.id == 1
			ids = [1]
		elsif last.id < 50
			ids = (1..last.id).to_a.sort{ rand() - 0.5 }[1..last.id]
		else
			ids = (1..last.id).to_a.sort{ rand() - 0.5 }[1..50]
		end
		@img = Array.new
		ids.each do |id|
			hash = Hash.new
			user = User.find_by(id: id)
			puts id
			puts user
			hash[:img] = cipher.encrypt(user.email + '_' + (user.photo_count - 1 ).to_s) if user.present?
			hash[:id] = id if user.present?
			@img << hash if user.present?
		end
	end

	private

		def participante_params
			params.require(:participante).permit(:nombre, :fecha_nacimiento, :provincia_id, :email)
		end

		def check_participante_registrado
			participante = Participante.find_by(email: participante_params[:email])
			if participante.present?
				redirect_to main_felicidades_path(sc: participante.id) and return
			end
		end
	
end
