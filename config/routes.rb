Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :employees, only: %i[index] do
        collection do
          get :pending_approval
        end
        resources :worksheets, only: %i[index create update]
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
