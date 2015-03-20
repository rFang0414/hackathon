class SpreadController < ApplicationController
    def get_job
      @job = Job.find_by(id: params[:id].to_i)
      @node_id = params[:node_id].blank? ? encode("0") : params[:node_id]

      @resume = Resume.new
    end

    def my_resume

    end

    def share
        #binding.pry
      user_phone = params[:telephone]
      user_name = params[:name]
      node_id = params[:node_id]
      job_id = params[:job_id]
      previous_id = decode(node_id)

      node = Node.find_by(user_phone:user_phone,job_id:job_id)
      node = Node.create(previous_id:previous_id,user_phone:user_phone,job_id:job_id) if node.blank?
      new_node_id = encode(node.id.to_s)

      player = Player.find_or_initialize_by(phone:user_phone)
      player.update(name:user_name)

      #redirect_to '/spread/job/' + job_id + "?node_id=" + new_node_id
      render json: Node.first
    end

    def remote_share
      user_phone = params[:telephone]
      user_name = params[:name]
      node_id = params[:node_id]
      job_id = params[:job_id]
      previous_id = decode(node_id)

      node = Node.find_by(user_phone:user_phone,job_id:job_id)
      node = Node.create(previous_id:previous_id,user_phone:user_phone,job_id:job_id) if node.blank?
      new_node_id = encode(node.id.to_s)

      player = Player.find_or_initialize_by(phone:user_phone)
      player.update(name:user_name)

      #redirect_to '/spread/job/' + job_id + "?node_id=" + new_node_id
      render json: {:node_id => new_node_id}.to_json
    end


    def generate_list_node(node_id)
      tree_nodes = []
      while node_id != '0'
        tree_node = {}
        node = Node.find_by(id:node_id)
        user = Player.find_by(phone:node.user_phone)
        tree_node[:name] = user.name
        tree_node[:phone] = user.phone

        node_id = node.previous_id
        tree_nodes << tree_node
      end
      tree_nodes
    end

    def remote_update_resume
        resume = Resume.create(params.permit![:resume])

        render :nothing => true
    end

    def tree
      @tree = generate_list_node(4).to_json
    end

    def remote_check_resume
        phone = params[:telephone]
        

        resume = Resume.find_by(phone_number: phone)
        has_resume = resume.blank? ? "false" : "true" 
        render json: {:has_resume => has_resume}.to_json
    end

end
