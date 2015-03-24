require 'securerandom'

class Api::RoomsController < ApiController

	before_filter :authenticate_request
	before_filter :find_room, except: [:create, :index, :show, :search]

	api!
	def create
		@user = Api::User.find params[:user_id]

		if @user.id == current_user.id
			
			@room = @user.owned_rooms.create!(:name => room_params[:name])

			if(room_params.has_key?(:users))
				
				@users = room_params[:users]

				@users.each_with_index do |val, index| 
					#puts "#{val} => #{index}" 
					user_id = Integer(val)
					user = Api::User.find user_id;

					if(user.present?)
						@room.invite_user user
					end
				end
			end
			
			render :json =>  @room.to_json(:include => [:users, :stories]), status: :created

		else
			render nothing: true, status: :bad_request
		end
	end

	api!
	def destroy
		if @room.is_owner? current_user  
			@room.destroy!
			render json: { message: 'Room destroyed' }, status: 200
		else
			render nothing: true, status: 404
		end
	end

	api!
	def index
		@rooms = current_user.all_rooms
    	render json: @rooms.to_json(:include => [:users, :owner]), status: :ok
	end

	api!
	def update
		if @room.is_owner? current_user

			@room.update!(room_params)

			render json: @room
		else
			render nothing: true, status: 404
		end
	end

	api!
	def stories

		if(params.has_key?(:tag))
			#puts params[:tag]
			render json: @room.stories_with_tag(params[:tag]), status: :ok
		elsif (params.has_key?(:user))
			render json: @room.stories_of_user(params[:user]), status: :ok
		else
			render json: @room.stories, status: :ok
		end		
	end

	api!
	def index_users

		#puts @room.participants.inspect
		render json: @room.participants, status: :ok
	end

	api!
	def remove_story
		
		@story = Api::Story.find params[:story_id]

		if(@story.is_owner?(current_user))
			@room.stories.delete(@story)

			render json: { message: 'Story removed' }, status: :ok
		else
			render nothing: true, status: 404
		end
	end

	api!
	def remove_user
		u = Api::User.find params[:user_id]

		#Le owner ne peut pas quitter la room
		if(u.id == current_user.id)
			@room.users.delete(current_user)
			render json: { message: "User removed from room #{@room.id}" }, status: :ok
		else
			render nothing: true, status: 404
		end
	end

	api!
	def add_users
		if(room_params.has_key?(:users))

			@users = room_params[:users]

			@users.each_with_index do |val, index| 	
				user_id = Integer(val)
				user = Api::User.find user_id;

				if(user.present? and current_user.friends.include?(user) and @room.is_owner?(current_user) and not @room.users.include?(user))
					@room.users << user
				end
			end

			if @room.save
				render :json =>  @room.to_json(:include => [:users, :stories]), status: :created
			else
				render nothing: true, status: :bad_request
			end
		else
			render nothing: true, status: :bad_request
		end
	end

	private
		def find_room
			begin
				@room = Api::Room.find params[:id]
				if not current_user.can_access_room? @room
					render nothing: true, status: :not_found
				end
			rescue ActiveRecord::RecordNotFound
				render nothing: true, status: :not_found
			end
		end

		def room_params
			params.require(:room).permit(:name, :users => [])
		end

		def find_users
			if(room_params.has_key?(:users))
				@users = room_params[:users]
			end
		end
end