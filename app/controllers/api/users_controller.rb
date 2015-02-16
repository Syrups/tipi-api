require 'securerandom'

class Api::UsersController < ApiController

  # Verify request authentication for all endpoints
  # except user creation
  before_filter :authenticate_request, except: :create
  before_filter :find_user, except: :create
  before_filter :check_access, except: [:create, :show]

  api!
  def create
    user = user_params
  	@user = Api::User.find_by_username(user[:username])

  	# Respond with 409 conflict if username is already taken
  	if @user.present?
  	  render nothing: true, status: :conflict 
  	else
    	salt = SecureRandom.hex
    	password = Security.hash_password(user[:password], salt)
      token = Security.generate_token(user[:username])

    	@user = Api::User.new(username: user[:username], password: password, salt: salt, token: token)

    	if @user.save
    	  render json: @user, status: :created
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
    @user.update!(user_params)

    render json: @user
  end

  api!
  def destroy
    @user.destroy!

    render json: { message: 'User destroyed' }, status: 200
  end

  api!
  def subscribers
    render json: @user.subscribers, status: :ok
  end

  api!
  def subscribed
    render json: @user.subscribed, status: :ok
  end

  def invitations
    render json: @user.invitations, status: :ok
  end

  private
  	def find_user
  	  @user = Api::User.find params[:id]
  	  render nothing: true, status: :not_found unless @user.present? and @user.id == current_user.id
  	end

    def check_access
      if @user.nil?
        @user = Api::User.find(params[:id])
      else
        if @user.id != current_user.id
          render nothing: true, status: :not_found
        end
      end
    end

    def user_params
      params.require(:user).permit(:username, :password, :type)
    end
end
