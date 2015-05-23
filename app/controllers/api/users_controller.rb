require 'securerandom'

class Api::UsersController < ApiController

  # Verify request authentication for all endpoints
  # except user creation
  before_filter :authenticate_request, except: :create
  before_filter :find_user, except: [:create, :index, :search]
  before_filter :check_access, except: [:create, :index, :show, :search]

  api!
  def create
    user = user_params
  	@user = Api::User.find_by_username(user[:username])

  	# Respond with 409 conflict if username is already taken
  	if @user.present?
  	  render nothing: true, status: :conflict 
  	else
    	salt = SecureRandom.hex
    	password = ::Security.hash_password(user[:password], salt)
      token = ::Security.generate_token(user[:username])

    	@user = Api::User.new(username: user[:username], device_token: user[:device_token], device_type: user[:device_type], password: password, salt: salt, token: token)

    	if @user.save!
    	  render json: @user, status: :created
    	else
    	  render nothing: true, status: :bad_request
      end
    end
  end

  api!
  def index # list of public broadcasters
    render json: Api::User.public_people
  end

  api!
  def show
    render json: @user.json_with_audio_and_stories
  end

  api!
  def search
    results = Api::User.search params[:query]
    render json: results
  end
  
  api!
  def update
    @user.update!(user_params)

    if params[:user][:audio].present?
      audio = @user.create_audio(audio_params)
    end

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
    render json: @user.requesting_rooms.to_json(:include => :owner), status: :ok
  end

  api!
  def created
    @stories = current_user.stories
   
    render json: @stories, status: :ok
  end

  api!
  def received
    @stories = current_user.received_stories
    render json: @stories, status: :ok
  end

  api!
  def tags
    stories = @user.stories.order('created_at DESC')
    tags = []

    stories.each do |s|
      tags << s.tag
    end

    render json: tags
  end

  private
  	def find_user
      if params[:user_id].present?
        id = params[:user_id]
      else
        id = params[:id]
      end

      begin
        @user = Api::User.includes(:stories).find id
      rescue ActiveRecord::RecordNotFound
        render nothing: true, status: :not_found
      end
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
      params.require(:user).permit(:username, :password, :account_type, :audio, :device_token, :device_type)
    end

    def audio_params
      params.require(:user).require(:audio).permit(:file)
    end
end
