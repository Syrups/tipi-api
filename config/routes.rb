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
          end
        end

        resources :subscriptions, shallow: true, only: [:index, :create, :update]

        get '/subscribed', on: :member, to: 'users#subscribed'
        get '/subscribers', on: :member, to: 'users#subscribers'
      end

    end
  end
end
