class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
 
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  protected
   
  def configure_permitted_parameters
  	devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
  	devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :username, :email, :address, :city, :state, :country, :zip, :facebook_link, :twitter_link, :linkedin_link, :avatar, :password, :password_confirmation, :current_password) }
  	devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :name, :email, :password, :password_confirmation) }
  	
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(User) && resource.banned?
      sign_out resource
      flash[:notice] = 'Oops! Seems You are not authenticated to use this site anymore.'
      root_path(locale: I18n.locale)
    else
     super
    end
  end

end
