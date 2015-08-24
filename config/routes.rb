Rails.application.routes.draw do
  constraints format: :json do
    resources :funnels, only: [:index]
    resources :validations, only: [] do
      collection do
        get :email
        get :phone
      end
    end
  end

  resources :apply, only: [:index, :create, :update] do
    collection do
      get :details
      get :quiz
      post :save_quiz, path: 'save-quiz'
      get :background_check, path: 'background-check'
      get :confirmation
      post :find_existing, path: 'find-existing-application'
    end
  end

  root to: 'home#index'
end
