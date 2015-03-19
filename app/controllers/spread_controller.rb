class SpreadController < ApplicationController
    def get_job
      @job = Job.find_by(id: params[:id].to_i)
      @node_id = params[:node_id].blank? ? encode("0") : params[:node_id]
    end

    def my_resume

    end

    def share
      user_phone = params[:telephone]
      user_name = params[:name]
      node_id = params[:node_id]
      job_id = params[:job_id]
      previous_id = decode(node_id)

      node = Node.create(previous_id:previous_id,user_phone:user_phone,job_id:job_id)
      new_node_id = encode(node.id.to_s)

      Player.create(name:user_phone,phone:user_phone)

      redirect_to '/spread/job/' + job_id + "?node_id=" + new_node_id
    end


    def generate_list_node

    end

end
