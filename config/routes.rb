Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

  # this added the root route and also create a root_path
  root 'static_pages#home'
  # each of this get produced a named route called help_path, about_path,
  # etc
  get 'help' => 'static_pages#help'
  get 'about' => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  
  get 'signup' => 'users#new'
  
  # these routes are added for the REST for sessions; however, we don't
  # use the full REST, which is why we specify the named routes instead
  # of using the resources like for users. this is from section 8.1.1
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  
  # added in 7.1.2 to turn users into resources in order to use the
  # REST architecture and the named routes; refer to table 7.1 to see
  # all the named route that is added by default
  # modified in listing 12.15 to take into account the following and
  # followers resource
  resources :users do
    member do
      get :following, :followers
    end
  end
  # we can see a full list of the routes for the applications, including
  # the named routes, using $ bundle exec rake routes
  
  # added in listing 10.1, we use the standard REST URL for
  # account_activations; since account_activation requires the edit action
  # but only the edit action we included the only: so that only the edit
  # named route would be included
  resources :account_activations, only: [:edit]
  
  # this is added from listing 10.37. We need routes for creating new
  # password resets and for updating them, therefore we need routes for
  # new, create, edit, and update
  resources :password_resets, only: [:new, :create, :edit, :update]
  # added in listing 11.29, we only define the create and destroy,
  # because for micropost the interface will run principally through
  # the profile and home pages; ie, since we don't need a view for
  # new and edit page, we also don't need the route for the view
  resources :microposts, only: [:create, :destroy]
end
