Grapevine::Application.routes.draw do
  resources :feeds do
    get :tweets, on: :member, to: "feeds#tweets"
    get :status, on: :collection, to: "feeds#status"
  end

  root "feeds#index"
end
