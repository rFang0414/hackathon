class SpreadController < ApplicationController
    def get_job
      @job = Job.find_by(id: params[:id].to_i)
      @node_id = params[:node_id].blank? ? encode("0") : params[:node_id]

      @resume = Resume.new
    end

    def poster_show_job
      @job = Job.find_by(id: params[:id].to_i)

      if @job.blank?
        @job = Job.new
      end
    end

    def poster_update_job
      #binding.pry
      job = Job.find_by(id: params[:id].to_i)
      if job.blank?
        Job.create(params.permit![:job])
      else
        Job.update(params[:id],params.permit![:job])
      end

      # if WechatResume.find_by(openid: params["openid"]).blank?
      #   resume = WechatResume.new(params.permit![:wechat_resume])
      #   resume.save
      #   result = resume
      # else
      #   result = WechatResume.update(params["openid"],params.permit![:wechat_resume])
      # end
      render :nothing => true
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


    def generate_list_node(application_id)
      node_id = Application.find_by(id:application_id).node_id
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
        application = Application.create(job_id:params[:job_id],node_id:decode(params[:node_id]),resume_id:resume.id)
        render :text => !application.blank?
    end

    def tree
      application_id = params[:id]
      @tree = generate_list_node(application_id)
      @hired = Resume.find_by(id:Application.find_by(id:application_id).resume_id)
    end

    def remote_check_resume
        phone = params[:telephone]

        resume = Resume.find_by(phone_number: phone)
        has_resume = resume.blank? ? false : true
        application = Application.find_by(job_id:params[:job_id],resume_id:resume.id) if has_resume == true

        render json: {:has_resume => has_resume, :has_application => !application.blank?}.to_json
    end

    def remote_apply
      resume = Resume.find_by(phone_number: params[:telephone])
      application = Application.create(job_id:params[:job_id],node_id:decode(params[:node_id]),resume_id:resume.id)
      render :text => !application.blank?
    end

    def remote_test_apply
      mailer = AmazonSes::Mailer.new(:access_key => "AKIAJXS5X7GZDEBIGPNA", 
        :secret_key => "Mtqa7h61ORrz5njPeIlNB2Z/1Y9Q2UFPt0koA9K/")

      mailer.deliver to: params[:email],
                     from:'875369936@qq.com',
                     subject:'Your application has been received.',
                     body:'You have applied this job successfully.

Thanks!
Careerbuilder'

      render :text => params[:email]
    end

end
