Rails.application.routes.draw do


  apipie
  # Api scoping and versioning
  scope '/api' do
    scope '/v1' do

      get '/authenticate', to: 'api#authenticate'

      resources :users, module: :api, except: [:index, :new, :edit] do
        resources :stories, shallow: true, except: [:index, :new, :edit] do
          resources :pages,  shallow: true, except: [:index, :new, :edit] do
            resource :media,  shallow: true, except: [:index, :new, :edit]
            resource :audio,  shallow: true, except: [:index, :new, :edit]
          end
        end
      end

    end
  end
end
