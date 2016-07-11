Rails.application.routes.draw do

  root 'logistic_meshes#index'

  resources :logistic_meshes do
    collection do
      get :route
    end
  end

end
