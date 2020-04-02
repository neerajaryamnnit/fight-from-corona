Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  mount Blazer::Engine, at: "blazer"
  root to: 'home#index'
  post "send_otp" => "users#send_otp"
  post "verify_otp" => "users#verify_otp"

  get "issues/list"
  post "issues/create"
end
