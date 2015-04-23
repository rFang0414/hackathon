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
      key = ""
      secret = ""

      Aws.config.update({region: 'us-west-2', credentials: Aws::Credentials.new(key,secret)})
      ses = Aws::SES::Client.new(region: Aws.config[:region],credentials: Aws.config[:credentials])

      from_erb_path = File.join(Rails.root, 'app', 'templates', 'welcome.html.erb')

      resp = ses.send_email(
        # required
        source: "liansh-19@hotmail.com",
        # required
        destination: {
          to_addresses: [params[:email]],
          cc_addresses: [],
          bcc_addresses: [],
        },
        # required
        message: {
          # required
          subject: {
            # required
            data: "Your application has been received",
            charset: "UTF-8",
            },
          # required
          body: {
            text: {
              # required
              data: "",
              charset: "UTF-8",
            },
            html: {
              # required
              data: File.read(from_erb_path),
              charset: "UTF-8",
            },
          },
        },
        reply_to_addresses: ["liansh-19@hotmail.com",],
        return_path: "liansh-19@hotmail.com",
      )

      render :text => File.read(from_erb_path)
    end

    def remote_test_subscribe
      render :text => "hello"
    end

    def get_edm
      @email_template = EmailTemplate.find_by(id: params[:id].to_i)

      if params[:id].to_i == 0 || @email_template.blank?
        @email_template = EmailTemplate.new
      end
    end

    def post_edm
      file = Roo::Excel.new(params["upfile"].path)
      file.row(1)[0]

      keyword_row = file.row(1)
      email_value_row_list = Array.new

      i = 2
      while not file.row(i)[0].blank? do
        email_value_row_list.push(file.row(i))
        i +=1
      end

      email_info = Array.new
      email_info.push(keyword_row)
      email_info.push(email_value_row_list)

      template_id = params[:id]

      #pry.binding
      Resque.enqueue(SleepingJob,email_info,template_id)
      render :text => "Success!"
    end

    def update_template
      #pry.binding
      if params[:email_template_id].to_i == 0 || EmailTemplate.find_by(id: params[:email_template_id].to_i).blank?
        @email_template = EmailTemplate.create(params.permit![:email_template])
      else
        @email_template = EmailTemplate.update(params[:email_template_id],params.permit![:email_template])
      end
      render :json => @email_template
    end

end
