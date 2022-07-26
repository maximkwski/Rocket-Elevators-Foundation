require 'rest_client'
require 'json'

class InterventionsController < ApplicationController
  # before_action :set_intervention, only: %i[ show edit update destroy ]
  respond_to :js, only: [:create]
  respond_to :html

  # GET /interventions or /interventions.json
  def index
    @interventions = Intervention.all
  end

  # GET /interventions/1 or /interventions/1.json
  def show
    @intervention = Intervention.find(params[:id])
  end

  # GET /interventions/new
  def new
    @intervention = Intervention.new
  end

  # GET /interventions/1/edit
  def edit
  end

  # POST /interventions or /interventions.json
  def create
    freshdesk_domain = ENV["BASE_URL"]
    user_name_or_api_key =  ENV["FRESH_KEY"]
    password_or_x = "X"
    
    customer_id = params["customers-input"]
    building_id = params["buildings-input"]
    battery_id = params["batteries-input"]
    column_id = params["columns-input"]
    elevator_id = params["elevators-input"]
    employee_id = params["employees-input"]
    report = params["description-input"]

    @intervention = Intervention.new(intervention_params)
    @intervention.author_id = current_user.id
    @intervention.customer_id = customer_id
    @intervention.building_id = building_id
    @intervention.battery_id = battery_id
    @intervention.column_id = column_id
    @intervention.elevator_id = elevator_id
    @intervention.employee_id = employee_id
    @intervention.report = report
    
    @intervention.save!
    if @intervention.save
      redirect_back fallback_location: new_intervention_path, notice: "Intervention was successfully created."

      intervention_payload =  {
        status: 3,
        priority: 3,
        type: "Problem",
        email: 'test@xyz.com',
        subject: "New Intervention Request #{Time.now}",
        description: "TESTING OUT EPSOM SALT LIFE"
        
        
        }
        freshdesk_api_path = 'api/v2/tickets'
        freshdesk_api_url  = "https://codeboxx777.freshdesk.com/#{freshdesk_api_path}"

        site = RestClient::Resource.new(freshdesk_api_url, user_name_or_api_key, password_or_x)
 
        begin
            response = site.post(intervention_payload.to_json, {content_type: :json, accept: :json})
            puts "response_code: #{response.code} \nLocation Header: #{response.headers[:Location]} \nresponse_body: #{response.body} \n"
        rescue RestClient::Exception => exception
            puts 'API Error: Your request is not successful. If you are not able to debug this error properly, mail us at support@freshdesk.com with the follwing X-Request-Id'
            puts "X-Request-Id : #{exception.response.headers[:x_request_id]}"
            puts "Response Code: #{exception.response.code} \nResponse Body: #{exception.response.body} \n"
        end


      else
        redirect_back fallback_location: root_path, notice: "Please sign up or sign in before submitting a quote!"

      respond_with(@qoute)
      
    end
  end

  # PATCH/PUT /interventions/1 or /interventions/1.json
  def update
    respond_to do |format|
      if @intervention.update(intervention_params)
        format.html { redirect_to intervention_url(@intervention), notice: "Intervention was successfully updated." }
        format.json { render :show, status: :ok, location: @intervention }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @intervention.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /interventions/1 or /interventions/1.json
  def destroy
    @intervention.destroy

    respond_to do |format|
      format.html { redirect_to interventions_url, notice: "Intervention was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_intervention
      @intervention = Intervention.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def intervention_params
      params.fetch(:intervention, {})
    end
end
