class TaskController < WebsocketRails::BaseController
  def initialize_session
    # perform application setup here
    controller_store[:message_count] = 0
  end

  def create
    # The `message` method contains the data received
    #pry.binding
    # task = Task.new message
    # pry.binding
    # if task.save
    #   send_message :create_success, task, :namespace => :tasks
    # else
    #   send_message :create_fail, task, :namespace => :tasks
    # end
    send_message :create_success, "hellocreate", :namespace => :tasks
  end

end