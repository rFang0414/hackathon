class SpreadController < ApplicationController
    #include ActionController::Live

    def get_job
      @job = Job.find_by(id: params[:id].to_i)
      @node_id = params[:node_id].blank? ? encode("0") : params[:node_id]

      @resume = Resume.new

      #WebsocketRails[:testchannel].trigger(:testevent, "hello111")
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
      key = ENV['AWS_ACCESS_KEY_ID']
      secret = ENV['AWS_SECRET_ACCESS_KEY']

      Aws.config.update({region: 'us-west-2', credentials: Aws::Credentials.new(key,secret)})
      ses = Aws::SES::Client.new(region: Aws.config[:region],credentials: Aws.config[:credentials])

      #from_erb_path = File.join(Rails.root, 'app', 'templates', 'welcome.html.erb')

      resp = ses.send_email(
        # required
        source: "liansh-19@hotmail.com",
        # required
        destination: {
          to_addresses: ["lian.winfa@gmail.com"],
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
              data: "Hello, this is an email",
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
      #pry.binding

      @email_info = EmailInfo.new
    end

    def post_email_info
      #binding.pry

      EmailInfo.delete_all


      file = Roo::Excel.new(params["upfile"].path)
      columns = get_file_colums(file.row(1).count)
      values = []

      values.push(file.row(1))
      i = 2
      while not file.row(i)[0].blank? do
        values.push(file.row(i))
        i +=1
      end

      EmailInfo.import columns, values
      render :json => {"emails"=>EmailInfo.first(5), "count"=>EmailInfo.count}
    end

    def post_edm
      template_id = 2

      #pry.binding
      #Resque.enqueue(SleepingJob,email_info,template_id)
      SendEmailJob.new.async.perform(template_id)
      render :text => "Success!"
    end

    def send_email
      #binding.pry
      template_id = params["template_id"]
      SendEmailJob.new.async.perform(template_id)
      #SendEmailJob.perform_later(template_id)
      # SendEmailJob.perform(2)
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

    def get_send_status
      email_info = EmailInfo.where("status = 'sent'").order("updated_at DESC").first
      
      all_count = EmailInfo.all.count
      send_count = EmailInfo.where("status = 'sent'").count

      if (send_count +1  < all_count)
        render :json => {"email"=>email_info.email, "count" => send_count}
      else
        render :json => {"email"=>"finished", "count" => send_count}
      end

    end

    def get_api_status

      #create_user
      email = "TestUser_" + "123" + "@sina.com.cn"
      user_data = 
      {
        "FirstName" => 'Test',
        "LastName" => 'User',
        "Email" => email,
        "Password" => 'Qwer1234!',
        "Phone" => '+657777888999',
        "City" => 'Singapore',
        "State" => 'SG',
        "CountryCode" => 'SG',
        "AllowNewsletterEmails" => false,
        "HostSite" => 'JC',
        "AllowPartnerEmails" => false,
        "AllowEventEmails" => false,
        "SendEmail" => false,
        "Gender" => 'U',
        "UserType" => 'jobseeker',
        "Status" => 'active'
      }

      t1 = Time.now
      result = Spear.create_user(user_data)
      t2 = Time.now
      ApiPerformance.create(api_name: "createUser",api_time: (t2-t1).to_s)
      result_hash = {"createUser" => result}

      external_user_id = result.response["ResponseUserCreate"]["ResponseExternalID"]
      external_user_id = "XRHS6896PJXVVMVKVXFX"

      #XRHS6896PJXVVMVKVXFX

      #retrieve_user
      t1 = Time.now
      result = Spear.retrieve_user(external_user_id, "Qwer1234!")
      t2 = Time.now
      ApiPerformance.create(api_name: "retrieveUser",api_time: (t2-t1).to_s)
      result_hash["createUser"] = result

      #create_resume
      resume_data = 
      {
        "ExternalUserID" => "XRHS6896PJXVVMVKVXFX",
        "ShowContactInfo" => true,
        "Title" => 'asasdasdasd',
        "ResumeText" => 'albee009@gmail.com JobsCentral999',
        "Visibility" => true,
        "CanRelocateNationally" => false,
        "CanRelocateInternationally" => false,
        "TotalYearsExperience" => 1,
        "HostSite" => 'T3',
        "DesiredJobTypes" => 'ETFE',
        "CompanyExperiences" => [],
        "Educations" => [],
        "Languages" => [],
        "CustomValues" => []
      }
      t1 = Time.now
      result = Spear.create_resume(resume_data)
      t2 = Time.now
      ApiPerformance.create(api_name: "createResume",api_time: (t2-t1).to_s)
      result_hash["createResume"] = result
      

      #retrieve_resume 
      t1 = Time.now
      result = Spear.retrieve_resume("XRHQ7VK5W7KHQBG009Y6","XRHS6896PJXVVMVKVXFX")
      t2 = Time.now
      ApiPerformance.create(api_name: "retrieveResume",api_time: (t2-t1).to_s)
      result_hash["retrieveResume"] = result

      #search_job
      #JHT0RP6CG2D178X1DFF
      t1 = Time.now
      result = Spear.search_job({:TalentNetworkDID => "TN812H85WFC5ZM7TC2RB", :SiteEntity => 'TalentNetworkJob', :CountryCode => 'CN'})
      t2 = Time.now
      ApiPerformance.create(api_name: "searchJob",api_time: (t2-t1).to_s)
      job_did = result.jobs[0].did
      result_hash["searchJob"] = result

      #retrieve_job
      t1 = Time.now
      result = Spear.retrieve_job("JHT0RP6CG2D178X1DFF")
      t2 = Time.now
      ApiPerformance.create(api_name: "retrieveJob",api_time: (t2-t1).to_s)
      result_hash["retrieveJob"] = result

      #application_blank
      t1 = Time.now
      app_blank = Spear.application_blank("jhn2dt6d513vxy7s18y")
      t2 = Time.now
      ApiPerformance.create(api_name: "applicationBlank",api_time: (t2-t1).to_s)
      result_hash["applicationBlank"] = app_blank


      if app_blank.success?
        questions = []
        app_blank.questions.each do |q|
          if 'ApplicantName'.eql?(q.id)
            questions << {QuestionID: q.id, ResponseText: "TestName"}
          elsif 'ApplicantEmail'.eql?(q.id)
            questions << {QuestionID: q.id, ResponseText: "lian_test@yahoo.com"}
          elsif 'Resume'.eql?(q.id)
            questions << {QuestionID: q.id, ResponseText: "My Resume"}
          end
        end
      end

      #application_submit
      t1 = Time.now
      app_submit = Spear.application_submit("jhn2dt6d513vxy7s18y", questions,true)
      t2 = Time.now
      ApiPerformance.create(api_name: "applicationSubmit",api_time: (t2-t1).to_s)
      result_hash["applicationSubmit"] = app_submit


      render :json => result_hash

    end

    def get_api_result
      @apis = ApiPerformance.select(:api_name).uniq
      # apis.each do |a| 
      #   api_times = ApiPerformance.where(:api_name=>a.api_name).select(:api_time)

      #   count = 0
      #   time_all = 0
      #   api_times.each do |api_time|
      #     time_all = time_all + api_time.api_time.to_f
      #     count = count +1
      #   end
      #   puts a.api_name + (time_all/count).to_s
      # end
      render :noting => true
    end
    
    private
    def get_file_colums colums_number
        #binding.pry
        if colums_number == 1
          return [:email]
        elsif colums_number == 2
          return [:email, :field_1]
        elsif colums_number == 3
          return [:email, :field_1, :field_2]
        elsif colums_number == 4
          return [:email, :field_1, :field_2, :field_3]
        elsif colums_number == 5
          return [:email, :field_1, :field_2, :field_3, :field_4]
        elsif colums_number == 6
          return [:email, :field_1, :field_2, :field_3, :field_4, :field_5]
        end
    end

end
