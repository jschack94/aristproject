Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    post '/register', to: 'devices#register'
    post '/alive', to: 'devices#alive'
    post '/report', to: 'devices#report'
    put '/terminate', to: 'devices#terminate'
  end
end
