Rails.application.routes.draw do
  root "recipes#index"

  resources :recipes do
    resources :steps, only: %i[create update destroy]
    get 'new_ingredient_field', on: :collection
     get 'new_step_field', on: :collection 
  end
end
