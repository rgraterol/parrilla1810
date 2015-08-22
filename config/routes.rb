Rails.application.routes.draw do

 root 'main#index'

 post 'upload_img', to: 'uploads#img', as: :upload_img

 post 'load_main_frame', to: 'main#load_main_frame', as: :load_main_frame
end
