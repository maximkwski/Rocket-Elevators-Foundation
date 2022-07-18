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

    # def confirmation_email
    #     attachments.inline["R2.png"] = File.read("#{R2.png}/app/views/layouts/R2.png")
    #     # mail(to: email, subject: 'test subject')
    # end
    
    def create 

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
        redirect_back fallback_location: root_path, notice: "Success!"
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

    private
    def lead_params
            if params[:lead] == nil
                params.fetch(:lead, {})
            else
                params.require(:lead).permit(:name, :email, :phone, :company_name, :project_name, :project_description, :department, :message, :attachment)
            end
    end
end
