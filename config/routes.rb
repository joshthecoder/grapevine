Grapevine::Application.routes.draw do
  resources :feeds

  root "feeds#index"
end
