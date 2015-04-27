WebsocketRails::EventMap.describe do
  namespace :tasks do

        # using a Hash to specify the target
        subscribe :create, :to => TaskController, :with_method => :create

        # # using the same syntax as routes.rb
        # subscribe :update, 'task#update'

        # # if your controller is not a top-level object
        # subscribe :create_admin, :to => Admin::TaskController, :with_method => :create

        # subscribe :update_admin, 'admin/task#update'
  end

  # namespace :websocket_rails do 
  #       subscribe :subscribe, to: WebsocketRailsController, with_method: :client_subscribed
  #       subscribe :subscribe_private, to: WebsocketRailsController, with_method: :client_subscribed_to_private
  #   end

end