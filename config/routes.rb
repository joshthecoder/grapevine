Grapevine::Application.routes.draw do
  resources :feeds do
    get :tweets, on: :member, to: "feeds#tweets"
  end

  root "feeds#index"
end
