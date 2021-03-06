Rails.application.routes.draw do


  apipie
  # Api scoping and versioning
  scope '/api' do
    scope '/v1' do

      post '/authenticate', to: 'api#authenticate'

      resources :users, module: :api, except: [:new, :edit], contraints: { id: /^[0-9]+$/} do
        resources :stories, shallow: true, except: [:index, :new, :edit] do
          resources :pages,  shallow: true, except: [:index, :new, :edit] do
            resource :media,  shallow: true, except: [:index, :new, :edit]
            resource :audio,  shallow: true, except: [:index, :new, :edit]
            resources :comments, shallow: true, except: [:new, :edit]
          end
        end

        resources :friends, only: [:create, :index] do
          delete '/', on: :collection, to: 'friends#destroy'
          put '/accept', on: :collection, to: 'friends#accept'
          get '/requests', on: :collection, to: 'friends#pending'
        end

        resources :rooms, shallow: true, except: [:new, :edit] do
          get '/stories', on: :member, to: 'rooms#stories'
          get '/users', on: :member, to: 'rooms#index_users'
          post '/users', on: :member, to: 'rooms#add_users'
          delete '/stories/:story_id', on: :member, to: 'rooms#remove_story'
          delete '/users/:user_id', on: :member, to: 'rooms#remove_user'
          post '/invite', on: :member, to: 'rooms#invite_user'
          post '/join', on: :member, to: 'rooms#join'
        end

        resources :subscriptions, shallow: true, only: [:index, :create, :update]


        get '/stories/created', on: :member, to: 'users#created'
        get '/stories/received', on: :member, to: 'users#received'
        get 'search', on: :collection, to: 'users#search'
        get '/subscribed', on: :member, to: 'users#subscribed'
        get '/subscribers', on: :member, to: 'users#subscribers'
        get '/invitations', on: :member, to: 'users#invitations'
        get '/tags', on: :member, to: 'users#tags'
        
      end

    end
  end

  match '*a', to: 'application#not_found', via: :all
end
