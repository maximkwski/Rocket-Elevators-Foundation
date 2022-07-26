require 'rest_client'
require 'json'
require 'sendgrid-ruby'
include SendGrid
require 'rubygems'
require 'nokogiri' 
require 'mailjet'


class LeadController < ApplicationController
    
    def index 
        @lead = Lead.all
    end
    
    def show 
        @lead = Lead.find(params[:id])
    end
    
    def new
        @lead = Lead.new
    end
    
    def create 
        freshdesk_domain = ENV["BASE_URL"]
        user_name_or_api_key =  ENV["FRESH_KEY"]
        password_or_x = "X"
        
        contact_name = params["name"]
        email = params["email"]
        phone = params["phone"]
        company_name = params["company"]
        project_name = params["project_name"]
        project_description = params["project_description"]
        department = params["department"]
        message = params["message"]
        attachment = params["attachment"]

        @lead = Lead.new(lead_params)

        @lead.name = params["name"]
        @lead.email = params["email"]
        @lead.phone = params["phone"]
        @lead.company_name = params["company"]
        @lead.project_name = params["project_name"]
        @lead.project_description = params["project_description"]
        @lead.department = params["department"]
        @lead.message = params["message"]
        # @lead.attachment = params["attachment"] || ""

        @lead.save!
        if @lead.save
            redirect_back fallback_location: root_path, notice: "Your contact request has been sent successfully!"

            multipart_payload =  {
                status: 2,
                priority: 1,
                type: "Question",
                email: @lead.email,
                phone: @lead.phone,
                cc_emails: ["support@codeboxx777.freshdesk.com"],    
                subject: "#{@lead.name} from #{@lead.company_name} sent contact request #{Time.now}",
                description: "#{@lead.name} from #{@lead.company_name} can be reached at email #{@lead.email} and at phone number #{@lead.phone}. <br/>
                            #{@lead.department} has a project named #{@lead.project_name} which would require contribution from Rocket Elevators. <br/>
                            Project description: #{@lead.project_description} <br/>
                            Attached Message: #{@lead.message}"
                
                
                }
                
                freshdesk_api_path = 'api/v2/tickets'
                freshdesk_api_url  = "https://codeboxx777.freshdesk.com/#{freshdesk_api_path}"

                site = RestClient::Resource.new(freshdesk_api_url, user_name_or_api_key, password_or_x)
 
                begin
                    response = site.post(multipart_payload.to_json, {content_type: :json, accept: :json})
                    # RestClient.post freshdesk_api_url, multipart_payload.to_json, {content_type: :json, accept: :json}
                    puts "response_code: #{response.code} \nLocation Header: #{response.headers[:Location]} \nresponse_body: #{response.body} \n"
                  rescue RestClient::Exception => exception
                    puts 'API Error: Your request is not successful. If you are not able to debug this error properly, mail us at support@freshdesk.com with the follwing X-Request-Id'
                    puts "X-Request-Id : #{exception.response.headers[:x_request_id]}"
                    puts "Response Code: #{exception.response.code} \nResponse Body: #{exception.response.body} \n"
                end
        end
                
        
        require 'mailjet'
        Mailjet.configure do |config|
        config.api_key = ENV['MAILJET_API_KEY']
        config.secret_key = ENV['MAILJET_SECRET_KEY']
        config.api_version = "v3.1"
        end
        variable = Mailjet::Send.create(messages: [{
          'From'=> {
            'Email'=> 'ryanzbanas@gmail.com',
            'Name'=> 'Rocket Elevators'
          },
          'To'=> [
            {
             'Email'=> @lead.email,
             'Name'=> @lead.name
            }
          ],
         'Subject'=> "Greetings #{@lead.name}",
          'TextPart'=> 'Rocket Elevators',
         'HTMLPart'=>  " <img src='https://maksymkproject.xyz/assets/R2-3c6296bf2343b849b947f8ccfce0de61dd34ba7f9e2a23a53d0a743bc4604e3c.png' alt='RE logo' height='20%'>        
             <h1> Greetings #{@lead.name}</h1>
             <p>We thank you for contacting Rocket Elevators to discuss the opportunity to contribute to your project #{@lead.project_name}.</p>
             <p>A representative from our team will be in touch with you very soon. We look forward to demonstrating the value of our solutions and helping you choose the appropriate product given your requirements.</p>
             <p>We’ll Talk soon. </p>
             <p>The Rocket Team.</p>
             ",
          'CustomID' => 'AppGettingStartedTest'
        }]
        )
        p variable.attributes['Messages']
    
            
    end

    # private
    # def lead_params
    #     params.fetch(:lead, {})
    # end

    private
    def lead_params
            if params[:lead] == nil
                params.fetch(:lead, {})
            else
                params.require(:lead).permit(:name, :email, :phone, :company_name, :project_name, :project_description, :department, :message, :attachment)
            end
    end
end
