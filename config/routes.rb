Rails.application.routes.draw do


  apipie
  # Api scoping and versioning
  scope '/api' do
    scope '/v1' do

      post '/authenticate', to: 'api#authenticate'

      resources :users, module: :api, except: [:index, :new, :edit] do
        resources :stories, shallow: true, except: [:index, :new, :edit] do
          resources :pages,  shallow: true, except: [:index, :new, :edit] do
            resource :media,  shallow: true, except: [:index, :new, :edit]
            resource :audio,  shallow: true, except: [:index, :new, :edit]
            resources :comments, shallow: true, expect: [:new, :edit]
          end
        end

        resources :subscriptions, shallow: true, only: [:index, :create, :update]

        get '/stories/created', on: :member, to: 'users#created'
        get '/stories/received', on: :member, to: 'users#received'
        get '/subscribed', on: :member, to: 'users#subscribed'
        get '/subscribers', on: :member, to: 'users#subscribers'
        get '/invitations', on: :member, to: 'users#invitations'
      end

    end
  end
end
