Rails.application.routes.draw do

 root 'main#index'

 #get '1810', to: 'main#index', as: :main_index

 post 'upload_img', to: 'uploads#img', as: :upload_img

 post 'load_main_frame', to: 'main#load_main_frame', as: :load_main_frame

 post 'registrar_participante', to: 'main#registrar_participante', as: :registrar_participante

 get 'felicidades', to: 'main#felicidades', as: :main_felicidades

 get 'galeria', to: 'main#galeria', as: :main_galeria

 namespace :dynamic_select do
  get ':region_id/provincias', to: 'provincias#index', as: 'provincias'
 end

end
