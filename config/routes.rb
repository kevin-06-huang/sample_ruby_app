Rails.application.routes.draw do
  # this added the root route and also create a root_path
  root 'static_pages#home'
  # each of this get produced a named route called help_path, about_path,
  # etc
  get 'help' => 'static_pages#help'
  get 'about' => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  
  get 'signup' => 'users#new'
  
  # added in 7.1.2 to turn users into resources in order to use the
  # REST architecture and the named routes; refer to table 7.1 to see
  # all the named route that is added by default
  resources :users
end
