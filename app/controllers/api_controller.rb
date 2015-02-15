class ApiController < ApplicationController

  def authenticate
  	render nothing: true, :status => :bad_request unless params[:user].present? and params[:signature].present?
  end

  private

  def authenticate_request
  	if not request.headers['X-Authorization-Token'].present?
  		render :json => { message: 'No token provided' }, :status => :unauthorized
      return
  	end

  	@current_user = Api::User.find_by_token(request.headers['X-Authorization-Token'])

  	if @current_user.nil?
  		render :json => { message: 'Bad token' }, :status => :unauthorized
      return
  	end
  end

  def current_user
  	@current_user
  end
end