MemberDirectory::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :admins, :controllers => { :omniauth_callbacks => "admins/omniauth_callbacks" }

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

  match '/members/newsletter', :to => 'newsletter_subscriptions#unsubscribe'

  resources :members, :only => [:index, :show, :update] do
    member do
      get :badge, defaults: {format: :js}
      get :thanks
      match :payment, via: [:get, :post]
    end
    collection do
      post :chargify_verify
      get :chargify_return
      get :summary, to: :summary, as: :summary, format: :xml
    end
  end

  resources :uploads, :only => [:new, :create] do
    collection do
      get :sample, defaults: {format: :csv}
    end
  end

  root :to => redirect("/members")

  get '/logos/:level/:size/:colour.svg', defaults: {format: :svg}, to: 'badge#logo'
  get '/logos/:level/:size/:colour.png', defaults: {format: :png}, to: 'badge#badge'
  get 'embed_stats.csv', to: 'embed_stats#index'

  get 'terms/:product' => 'home#terms'

  match '/401', :to => 'errors#unauthorized'
  match '/404', :to => 'errors#not_found'
  match '/500', :to => 'errors#server_error'

end
