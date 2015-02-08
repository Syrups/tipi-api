require 'securerandom'

class Api::UsersController < ApiController

  before_filter :find_user, only: [:show, :update, :destroy]

  api!
  def create
  	@user = User.find(username: params[:username])

  	# Respond with 409 conflict if username is already taken
  	if @user.present?
  	  render nothing: true, status: :conflict 
  	end

  	salt = SecureRandom.hex
  	password = hash_password(params[:password], salt)

  	@user = User.build(username: params[:username], password: password, salt: salt)

  	if @user.save
  	  render json: @user
  	else
  	  render nothing: true, status: :bad_request
    end
  end

  api!
  def show
  end
  
  api!
  def update
  end

  api!
  def destroy
  end

  private
  	def find_user
  	  @user = User.find params[:id]
  	  render nothing: true, status: :not_found unless @user.present? and @user.id == current_user.id
  	end

  	def hash_password(plain, salt)
  	  Digest::SHA2.new(512).digest(plain + ':' + salt)
  	end
end
