Rails.application.routes.draw do

  get 'calendar', to: 'calendar#agenda'

  get 'search', to: 'search#search'

  resources :courses do
    member do
      get 'activate', to: 'courses#activate_course'
      get 'explore', to: 'courses#explore'
    end
  end

  resources :assignments do
    member do
      post 'add_resource', to: 'assignments#add_resource', as: 'add_resource'
      post 'remove_resource', to: 'assignments#remove_resource', as: 'remove_resource'
    end
  end

  resources :readings do
    member do
      post 'add_resource', to: 'readings#add_resource', as: 'add_resource'
      post 'remove_resource', to: 'readings#remove_resource', as: 'remove_resource'
    end
  end

  resources :exams do
    member do
      post 'add_resource', to: 'exams#add_resource', as: 'add_resource'
      post 'remove_resource', to: 'exams#remove_resource', as: 'remove_resource'
    end
  end

  get 'resources/autocomplete'
  resources :resources do
    member do
      delete 'remove_file', to: 'resources#remove_file', as: 'remove_file'
    end
  end



  get 'login', to: 'login#new_session', as: 'login'

  get 'signup', to: 'users#signup', as: 'signup'
  get 'login/new_session'
  post 'create_session', to: 'login#create_session', as: 'create_session'
  delete 'logout', to: 'login#destroy_session', as: 'logout'
  get 'logout', to: 'login#destroy_session'



  post 'create_guest_account', to: 'users#create_guest_account', as: 'create_guest_account'
  get 'users/autocomplete', to: 'users#autocomplete', as: 'autocomplete_users'
  resources :users do

    member do
      post 'update_password'
    end
  end
  post 'change_avatar_face', to: 'avatars#change_face'
  post 'change_avatar_head', to: 'avatars#change_head'
  post 'change_avatar_color', to: 'avatars#change_color'

  get 'my_profile', to: 'users#my_profile', as: 'my_profile'




  root 'courses#index'


  get 'not_allowed' => 'users#not_allowed', as: :not_allowed





  match '*path', to: redirect('/'), via: :all

end
