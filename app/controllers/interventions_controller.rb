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
    @customers = Customer.all
    @buildings = Building.all
    @batteries = Battery.all
    @columns = Column.all
    @elevators = Elevator.all
    @employees = Employee.all

  end

  # GET /interventions/1/edit
  def edit
  end

  # POST /interventions or /interventions.json
  def create
    freshdesk_domain = ENV["BASE_URL"]
    user_name_or_api_key =  ENV["FRESH_KEY"]
    password_or_x = "X"
    
    @intervention = Intervention.new(intervention_params)
    @intervention.author_id = current_user.id
    # @intervention.customer_id = params["intervention_customer_id"]
    # @intervention.building_id = params["intervention_building_id"]
    # @intervention.battery_id = params["intervention_battery_id"]
    # @intervention.column_id = params["intervention_column_id"]
    # @intervention.elevator_id = params["intervention_elevator_id"]
    # @intervention.employee_id = params["intervention_employee_id"]
    @intervention.report = params["description-input"]
    
    @intervention.save!
    if @intervention.save
      redirect_back fallback_location: new_intervention_path, notice: "Intervention was successfully created."

      intervention_payload =  {
        status: 3,
        priority: 3,
        type: "Problem",
        email: @current_user.email,
        subject: "New Intervention Request #{Time.now}",
        description: "New Intervention request from a client ID: #{@intervention.customer_id}. Building ID: #{@intervention.building_id} "
        
        
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
        redirect_back fallback_location: root_path, notice: "Please sign up or sign in before submitting an intervention request."

      respond_with(@intervention)
      
    end
  end

  ### DYNAMIC SELECT DROPDOWN METHODS ###
  def get_buildings_by_customer
    @buildings = Building.where(customer_id: params[:id_value_string])
    puts params[:id_value_string]
    respond_to do |format|
      format.json { render :json => @buildings }
    end
  end 

  def get_batteries_by_building
    @batteries = Battery.where(building_id: params[:id_value_string])
    puts params[:id_value_string]
    respond_to do |format|
      format.json { render :json => @batteries }
    end
  end 

  def get_columns_by_battery
    @columns = Column.where(battery_id: params[:id_value_string])
    puts params[:id_value_string]
    respond_to do |format|
      format.json { render :json => @columns }
    end
  end 

  def get_elevators_by_column
    @elevators = Elevator.where(column_id: params[:id_value_string])
    puts params[:id_value_string]
    respond_to do |format|
      format.json { render :json => @elevators }
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
      # params.fetch(:intervention, {})
      params.require(:intervention).permit(:customer_id, :building_id, :battery_id, :column_id, :elevator_id, :employee_id)
    end
end
