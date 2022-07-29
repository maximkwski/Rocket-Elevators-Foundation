require 'rest_client'
require 'json'

class QuotesController < ApplicationController
    respond_to :js, only: [:create]
    respond_to :html

    def index
        @quotes = Quote.all
    end

    def show
        @quote = Quote.find(params[:id])
    end

    def new
        @quote = Quote.new
    end

    def create
        freshdesk_domain = ENV["BASE_URL"]
        user_name_or_api_key =  ENV["FRESH_KEY"]
        password_or_x = "X"

        building_type = params["building-type"]
        amount_of_floors = params["number-of-floors-input"]
        amount_of_elevators = params["elevator-amount"]
        final_price = params["final-price"]
        elevator_type = params[:product]
        installation_price = params["installation-fees"]

        @quote = Quote.new(quote_params)
        @quote.building_type = building_type
        @quote.amount_of_floors = amount_of_floors
        @quote.amount_of_elevators = amount_of_elevators
        @quote.final_price = final_price
        @quote.elevator_type = elevator_type
        @quote.installation_price = installation_price

        if user_signed_in?
            @quote.user_id = current_user.id
            @quote.save!
        
                if @quote.save
                    redirect_back fallback_location: new_quote_path, notice: "Quote has been sent successfully !"

                    quote_payload =  {
                        status: 2,
                        priority: 2,
                        type: "Feature Request",
                        email: @quote.user.email,
                        subject: "new quote request from #{@quote.user.company_name} #{Time.now}",
                        description: "#{@quote.user.company_name} has requested #{@quote.amount_of_elevators} elevators for a #{@quote.building_type} type of building with #{@quote.amount_of_floors} floors. <br/>
                        The client chose #{@quote.elevator_type} product type. After installation fees #{@quote.installation_price}, the final prise is #{@quote.final_price}. <br/>
                        Contact email #{@quote.user.email}"
                    }

                    freshdesk_api_path = 'api/v2/tickets'
                    freshdesk_api_url  = "https://codeboxx777.freshdesk.com/#{freshdesk_api_path}"

                    site = RestClient::Resource.new(freshdesk_api_url, user_name_or_api_key, password_or_x)
 
                    begin
                        response = site.post(quote_payload.to_json, {content_type: :json, accept: :json})
                        # RestClient.post freshdesk_api_url, multipart_payload.to_json, {content_type: :json, accept: :json}
                        puts "response_code: #{response.code} \nLocation Header: #{response.headers[:Location]} \nresponse_body: #{response.body} \n"
                    rescue RestClient::Exception => exception
                        puts 'API Error: Your request is not successful. If you are not able to debug this error properly, mail us at support@freshdesk.com with the follwing X-Request-Id'
                        puts "X-Request-Id : #{exception.response.headers[:x_request_id]}"
                        puts "Response Code: #{exception.response.code} \nResponse Body: #{exception.response.body} \n"
                    end
                    
                else
                    redirect_back fallback_location: root_path, notice: "Please sign up or sign in before submitting a quote!"
            
                respond_with(@quote)
                end
        end   
    end



    private
        def quote_params
            params.fetch(:quote, {})
        end

end
