module DynamicSelect
  class ProvinciasController < ApplicationController

    respond_to :json

    def index
      @provincias = Provincia.where(:region_id => params[:region_id])
      respond_with(@provincias)
    end
  end
end