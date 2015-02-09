require 'securerandom'

class Api::UsersController < ApiController

  # Verify request authentication for all endpoints
  # except user creation
  before_filter :authenticate_request, except: :create

  before_filter :find_user, only: [:show, :update, :destroy]

  api!
  def create
  	@user = Api::User.find_by_username(params[:username])

  	# Respond with 409 conflict if username is already taken
  	if @user.present?
  	  render nothing: true, status: :conflict 
  	else
    	salt = SecureRandom.hex
    	password = hash_password(params[:password], salt)

    	@user = Api::User.new(username: params[:username], password: password, salt: salt)

    	if @user.save
    	  render json: @user
    	else
    	  render nothing: true, status: :bad_request
      end
    end
  end

  api!
  def show
    render json: @user
  end
  
  api!
  def update
  end

  api!
  def destroy
  end

  private
  	def find_user
  	  @user = Api::User.find params[:id]
  	  render nothing: true, status: :not_found unless @user.present? and @user.id == current_user.id
  	end

  	def hash_password(plain, salt)
  	  Digest::SHA2.new(512).digest(plain + ':' + salt).hex
  	end
end
