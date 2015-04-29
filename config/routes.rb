Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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

  get 'spread/job/:id' => 'spread#get_job'

  get 'spread/poster/job/:id' => 'spread#poster_show_job'
  patch 'spread/poster/job/:id' => 'spread#poster_update_job'
  post 'spread/poster/job/:id' => 'spread#poster_update_job'
  post 'spread/remote/test/apply' => 'spread#remote_test_apply'
  post 'spread/remote/test/subscribe' => 'spread#remote_test_subscribe'

  match 'spread/resume/:id' , to: 'spread#my_resume' , via: [:get, :post]
  post 'spread/job/share', to: 'spread#share'
  post 'spread/job/remote/share', to: 'spread#remote_share'
  #match 'photos', to: 'photos#show', via: [:get, :post]
  post 'spread/remote/resume/:id' => 'spread#remote_update_resume'
  get 'tree/test/:id', to: 'spread#tree'
  post 'spread/remote/check/resume' => 'spread#remote_check_resume'
  post 'spread/remote/apply' => 'spread#remote_apply'

  mount Resque::Server.new, :at => "/admin/resque"

  get 'spread/edm/:id' => 'spread#get_edm'
  post 'spread/edm/:id' => 'spread#post_edm'

  post 'spread/template' => 'spread#update_template'
  #post 'spread/edm/template/:id', to: 'spread#update_template'

  get 'task' => 'task#get_index'
  get 'chat' => 'chat#chat'

  post 'spread/file' => 'spread#post_email_info'
  post 'spread/send' => 'spread#send_email'

  get 'spread/send/status' => 'spread#get_send_status'

  get 'event/status' => 'event_source#tester'
end
