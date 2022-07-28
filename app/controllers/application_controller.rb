class ApplicationController < ActionController::Base 
  
  rescue_from CanCan::AccessDenied do
    flash[:error] = 'Access denied!'
    redirect_to root_path
      end

      protect_from_forgery prepend: true  
      # protect_from_forgery with: :exception

     before_action :configure_permitted_parameters, if: :devise_controller?

     protected

          def configure_permitted_parameters
               devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:company_name, :email, :password)}

               devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:company_name, :email, :password, :current_password)}
          end

    # private
    # def authorize
    #     redirect_to root_path, alert: "Not authorized" if current_user.try(:admin) == false
    # end
end
