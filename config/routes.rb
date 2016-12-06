Rails.application.routes.draw do
  root :to => "static#index"

  resources :benchmarks do
    collection do
      get :method_create
      get :method_update
      get :method_where
      get :method_limit
      get :method_offset
      get :method_group
      get :method_select
    end
  end
end
