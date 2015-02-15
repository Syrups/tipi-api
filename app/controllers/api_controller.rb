class ApiController < ApplicationController

  VERSION = 1

  def authenticate
    user = Api::User.find_by_username params[:username]

    if user.present?
      credentials_password = Security.hash_password(params[:password], user.salt)

      if ::Devise.secure_compare(user.password, credentials_password)
        render json: user, status: 200
      else
        render nothing: true, status: 404
      end
    else
      render nothing: true, status: 404
    end
  end

  private

  def authenticate_request
    request_token = request.headers['X-Authorization-Token']

  	if not request_token.present?
  		render :json => { message: 'No token provided' }, :status => :unauthorized
  	end

  	@current_user = Api::User.find_by_token request_token

  	if @current_user.nil?
  		render :json => { message: 'Bad token' }, :status => :unauthorized
  	end
  end

  def current_user
  	@current_user
  end
end