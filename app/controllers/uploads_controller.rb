class UploadsController < ApplicationController
  respond_to :json

  def img
    @uploader = Upload.new(img: params[:upload][:file_input],
    						x: params[:x],
							y: params[:y],
							w: params[:w],
							h: params[:h])
    respond_to do |format|
    	if @uploader.save
    		format.js
    	end
    end	
  end
end
