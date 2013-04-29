MemberDirectory::Application.routes.draw do

  get "errors/not_found"

  get "errors/server_error"

  devise_for :members, :skip => [:sessions, :registrations]
  # Manually create session paths
  devise_scope :member do
    resource :member_session,
      only: [:new, :create, :destroy],
      path: 'session',
      controller: 'devise/sessions'
    resource :registration,
      only: [:new, :create, :destroy],
      path: 'members',
      controller: 'registrations',
      as: :member_registration do
        get :cancel
      end
  end
  
  resources :members, :only => [:index, :show, :update]
  
  root :to => "home#index"

  match '/401', :to => 'errors#unauthorized'
  match '/404', :to => 'errors#not_found'
  match '/500', :to => 'errors#server_error'

end
