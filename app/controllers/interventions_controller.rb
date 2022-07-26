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

    # respond_to do |format|
    #   if @intervention.save
    #     format.html { redirect_to intervention_url(@intervention), notice: "Intervention was successfully created." }
    #     format.json { render :show, status: :created, location: @intervention }
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #     format.json { render json: @intervention.errors, status: :unprocessable_entity }
    #   end
    # end
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
