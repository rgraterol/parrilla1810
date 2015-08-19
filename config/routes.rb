Rails.application.routes.draw do

 root 'main#index'

 post 'upload_img', to: 'uploads#img', as: :upload_img
end
