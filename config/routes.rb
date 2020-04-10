Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  mount Blazer::Engine, at: "blazer"
  root to: 'home#index'
  post "send_otp" => "users#send_otp"
  get "send_otp" => "users#send_otp"
  post "verify_otp" => "users#verify_otp"
  get "verify_otp" => "users#verify_otp"
  post "resend_otp" => "users#resend_otp"
  get "sign-up" => "users#sign_up"
  post "sign-up" => "users#sign_up_data"
  get "update-profile" => "users#update_profile"
  post "update-profile" => "users#update_profile_data"

  get "issues/list"
  get "issues/want_to_help"
  get "issues/create"
  post "issues/create"
  get "issues/categories"
  get "issues/sub_categories"
  post "issues/resolve"
  post "issues/call_pressed"
  post "issues/issue_help"
  get "issues/search_issues"
  get "users/change_locale"
end
