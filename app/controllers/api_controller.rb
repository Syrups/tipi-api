class ApiController < ApplicationController

  # Verify request authentication for all endpoints
  # except authentication one
  before_filter :authenticate_request, except: :authenticate

  def authenticate
  	render :json => 'Bad Request', :status => :bad_request
  end

  private

  def authenticate_request
  	if params[:token].nil? or params[:signature].nil?
  		render nothing: true, status: :unauthorized
  	end

  	user = User.find(token: params[:token])
  	
  end
end