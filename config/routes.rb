Rails.application.routes.draw do

  # Api scoping and versioning
  scope '/api', module: :api do
    scope '/v1' do

      get '/authenticate', to: 'application#authenticate'

      resources :users, except: [:index, :new, :edit] do
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
