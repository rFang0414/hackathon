class SleepingJob
    @queue = :food
 
  def self.perform (email_info, template_id)

      keyword_row = email_info[0]
      email_value_row_list = email_info[1]

      key = "AKIAIHFJKNSLLHVO7IHA"
      secret = "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"

      Aws.config.update({region: 'us-west-2', credentials: Aws::Credentials.new(key,secret)})
      ses = Aws::SES::Client.new(region: Aws.config[:region],credentials: Aws.config[:credentials])

      # from_erb_path = File.join(Rails.root, 'app', 'templates', 'welcome.html.erb')
      # email_html_template = File.read(from_erb_path)
      email_html_template = EmailTemplate.find_by(id: template_id.to_i).email_html

      email_value_row_list.each do |email_value_row|
        email_html = email_html_template
        
        keyword_row.each_with_index do |keyword, index|
            if email_html.include? "{$" + keyword_row[index] + "}"
                email_html = email_html.gsub("{$" + keyword_row[index] + "}", email_value_row[index])
            end
        end

        resp = ses.send_email(
            # required
            source: "liansh-19@hotmail.com",
            # required
            destination: {
              to_addresses: [email_value_row[0]],
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
            reply_to_addresses: ["liansh-19@hotmail.com",],
            return_path: "liansh-19@hotmail.com",
          )

      end
        puts 'I like to sleep3' 

      
    sleep 2
  end
end