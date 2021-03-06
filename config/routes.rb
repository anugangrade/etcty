Rails.application.routes.draw do

  resources :templates
  get "/templates/new/:type" => "templates#new", as: "new_template_type"

  scope "(:locale)", locale: /en|sp|fr/ do
    devise_for :users

    resources :coupen_types, :deal_types, :education_types, :sale_types, :coupens, :banners, :zones

    resources :categories do 
      resources :sub_categories
    end

    resources :institutes do
      resources :branches
    end

    resources :stores do
      resources :branches
    end

    resources :tutorials do
      member do
        get 'complete_order'
      end
    end

    resources :sales do
      member do
        get 'complete_order'
      end
    end

    resources :video_advs do
      member do
        get 'complete_order'
      end
    end

    resources :flyers do
      member do
        get 'complete_order'
      end
    end

    resources :educations do
      member do
        get 'complete_order'
      end
    end

    resources :deals do
      member do
        get 'complete_order'
      end
    end

    resources :advertisements do
      member do
        get 'complete_order'
      end
    end


    get 'home/index'
    get 'search/result' => "home#search_result"
    get '/modal/:id/:model' => "home#data_modal", as: "data_modal"
    post '/mail/:id/:model' => "home#data_emailable", as: "data_emailable"

    post 'search/result' => "home#search_result"
    get '/category_sub' => 'home#category_sub'
    get '/get_store' => 'home#get_store'
    get '/get_institute' => 'home#get_institute'
    get '/get_zone' => 'home#get_zone'
    get '/get_city' => 'home#get_city'
    get '/get_zip' => 'home#get_zip'
    get '/users' => 'home#users'
    get '/block_user/:id' => 'home#block_user', as: "block_user"
    get '/slider/update_content' => 'slider#update_content', as: "update_slider_content"
    get '/session/change_country' => 'home#change_session_country'
    

    # The priority is based upon order of creation: first created -> highest priority.
    # See how all your routes lay out with "rake routes".

    # Example of regular route:
    #   get 'products/:id' => 'catalog#view'

    # Example of named route that can be invoked with purchase_url(id: product.id)
    #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

    # Example resource route (maps HTTP verbs to controller actions automatically):
    #   resources :products

    # Example resource route with options:
    #   resources :products do
    #     member do
    #       get 'short'
    #       post 'toggle'
    #     end
    #
    #     collection do
    #       get 'sold'
    #     end
    #   end

    # Example resource route with sub-resources:
    #   resources :products do
    #     resources :comments, :sales
    #     resource :seller
    #   end

    # Example resource route with more complex sub-resources:
    #   resources :products do
    #     resources :comments
    #     resources :sales do
    #       get 'recent', on: :collection
    #     end
    #   end

    # Example resource route with concerns:
    #   concern :toggleable do
    #     post 'toggle'
    #   end
    #   resources :posts, concerns: :toggleable
    #   resources :photos, concerns: :toggleable

    # Example resource route within a namespace:
    #   namespace :admin do
    #     # Directs /admin/products/* to Admin::ProductsController
    #     # (app/controllers/admin/products_controller.rb)
    #     resources :products
    #   end
    get "/:id" => "stores#show", as: "store_show"
    get 'user/:username' => "home#profile", as: "profile"
  end
  # You can have the root of your site routed with "root"
  get '/:locale' => 'home#index'
  root 'home#index'

end
