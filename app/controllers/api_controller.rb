class ApiController < ApplicationController

  VERSION = 1

  def authenticate
  	render nothing: true, :status => :bad_request unless params[:user].present? and params[:signature].present?
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