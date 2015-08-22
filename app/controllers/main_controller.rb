class MainController < ApplicationController

	def index
	end

	def load_main_frame
		render partial: 'main'
	end
	
end
