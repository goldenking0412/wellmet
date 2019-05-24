class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  respond_to :html, :json

  after_filter :record_cordinates

  attr_accessor :login

  rescue_from CanCan::AccessDenied do |exception|
    render json: { errors: [exception.to_s] }, status: :unauthorized
  end

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :date_of_birth, :gender, :location, :policy) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end

  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  def user_cordinates
    @user_cordinates = begin
      if current_user.location
        geo_location = Geocoder.coordinates(current_user.location)
        if geo_location
          { latitude: geo_location[0], longitude: geo_location[1] }
        end
      end
    end
  end
  helper_method :user_cordinates

  private

  def record_cordinates
    current_user.update_geolocation user_cordinates if current_user && user_cordinates
  end


end
