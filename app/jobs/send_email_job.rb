class SendEmailJob < ActiveJob::Base
  #queue_as :default
  include SuckerPunch::Job

  # after_perform do |job|
  #   WebsocketRails[:channel_shanwa].trigger :event_shanwa, EmailInfo.all.map{|email_info| email_info.email }.join(', ')
  # end

  def perform (template_id)

      key = ENV['AWS_ACCESS_KEY_ID']
      secret = ENV['AWS_SECRET_ACCESS_KEY']

      Aws.config.update({region: 'us-west-2', credentials: Aws::Credentials.new(key,secret)})
      ses = Aws::SES::Client.new(region: Aws.config[:region],credentials: Aws.config[:credentials])

      keyword_row = EmailInfo.first
      email_value_row_list = EmailInfo.all
      email_html_template = EmailTemplate.find_by(id: template_id.to_i).email_html

      email_value_row_list.each do |email_value_row|
        #binding.pry
        email_html = get_email_template(email_html_template, keyword_row, email_value_row)

        if email_value_row.email != "Email"
          #WebsocketRails[:channel_shanwa].trigger(:event_shanwa,email_value_row.email )
          send_email(ses,"liansh-19@hotmail.com",email_value_row.email,email_html)
          puts 'Sending Email to' + email_value_row.email 
          email_value_row.status = "sent"
          email_value_row.save
        end

      end

  end

  private 
  def get_email_template(email_html_template, keyword_record, value_record)
      #binding.pry
      email_html = email_html_template

      if !keyword_record.field_1.blank?
        keyword_1 = "{$" + keyword_record.field_1+ "}"
        if (email_html_template.include? keyword_1) && (!value_record.field_1.blank?)
            email_html = email_html.gsub(keyword_1, value_record.field_1)
        end
      end

      if !keyword_record.field_2.blank?
        keyword_2 = "{$" + keyword_record.field_2+ "}"
        if (email_html_template.include? keyword_2) && (!value_record.field_2.blank?)
            email_html = email_html.gsub(keyword_2, value_record.field_2)
        end
      end

      if !keyword_record.field_3.blank?
        keyword_3 = "{$" + keyword_record.field_3+ "}"
        if (email_html_template.include? keyword_3) && (!value_record.field_3.blank?)
            email_html = email_html.gsub(keyword_3, value_record.field_3)
        end
      end

      if !keyword_record.field_4.blank?
        keyword_4 = "{$" + keyword_record.field_4+ "}"
        if (email_html_template.include? keyword_4) && (!value_record.field_4.blank?)
            email_html = email_html.gsub(keyword_4, value_record.field_4)
        end
      end

      if !keyword_record.field_5.blank?
        keyword_5 = "{$" + keyword_record.field_5+ "}"
        if (email_html_template.include? keyword_5) && (!value_record.field_5.blank?)
            email_html = email_html.gsub(keyword_5, value_record.field_5)
        end
      end

      return email_html
  end

  private 
  def send_email(ses, from_email, to_email, email_html)
    resp = ses.send_email(
            # required
            source: from_email,
            # required
            destination: {
              to_addresses: [to_email],
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
                  data: email_html,
                  charset: "UTF-8",
                },
              },
            },
            reply_to_addresses: [from_email,],
            return_path: from_email,
    )
  end
end