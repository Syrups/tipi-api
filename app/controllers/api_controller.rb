class ApiController < ApplicationController

  def authenticate
  	render nothing: true, :status => :bad_request unless params[:user].present? and params[:signature].present?
  end

  private

  def authenticate_request
  	if not params[:token].present?
  		render json: 'No token provided', status: :unauthorized
  	end

  	@current_user = Api::User.find_by_token(params[:token])

  	if @current_user.nil?
  		render json: 'Bad token', status: :unauthorized
  	end
  end

  def current_user
  	@current_user
  end
end