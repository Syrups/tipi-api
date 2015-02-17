class ApplicationController < ActionController::Base

  protect_from_forgery with: :null_session

  rescue_from ActionController::ParameterMissing, with: -> { render nothing: true, status: :bad_request }

  def not_found
  	render json: "No such endpoint: #{request.method} #{request.path}", status: :not_found
  end

  def server_error(e)
  	logger.warn "EXCEPTION RAISED: #{e.inspect}"
  	render nothing: true, status: :server_error
  end
end
