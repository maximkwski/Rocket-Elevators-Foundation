class EmployeeController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource
end

def show
    @admin = Admin.find(params[:id])
    authorize! :show, @admin
  end
