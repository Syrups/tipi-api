require 'securerandom'

class Api::StoriesController < ApiController
	before_filter :authenticate_request
	before_filter :find_story, except: :create

	api!
	def create
		@user = Api::User.find params[:user_id]

		if @user.id == current_user.id
			@story = @user.stories.create!(story_params)

			if(story_params.has_key?(:page_count))
				page_number = Integer(story_params[:page_count])
				page_number.times do |i|
					@story.pages << Api::Page.new
				end
			end


			if (params[:story].has_key?(:rooms))
				@rooms = params[:story][:rooms]
				@rooms.each_with_index do |val, index|
					room_id = Integer(val)
					room = Api::Room.find room_id

					if room.present?

						# Check that the user CAN post a story in this room,
						# i.e if he's the owner or an included user of this room
						if room.participants.include?(current_user)
							@story.rooms << room

							# Notify all members of the room
							::Push.send_to_many(room.participants, "A new story has been posted by "+@user.username+" in room "+room.name)
						else
							render nothing: true, status: :not_found and return
						end
					end
				end
			end

			if @story.save
				render :json => @story.to_json(:include => :pages), status: :created
			else
				render nothing: true, status: :bad_request
			end
		else
			render nothing: true, status: :bad_request
		end
	end

	api!
	def show
		begin
			@story = Api::Story.find params[:id]
		rescue ActiveRecord::RecordNotFound
			render nothing:true, status: :not_found
		end

		if @current_user.id == @story.user_id
			render json: @story.json_with_pages
		else
			if @story.receivers.include?(@current_user)
				render :json => @story.to_json(:include => [:receivers, :pages]) 
			else
				render nothing: true, status: :unauthorized
			end
		end
	end

	api!
	def destroy
		if @story.is_owner? current_user  
			@story.destroy!
			render json: { message: 'Story destroyed' }, status: 200
		else
			render nothing: true, status: 404
		end
	end

	api!
	def update
		if @story.is_owner? current_user
			@story.update!(story_params)

			# Once the story is published,
			# each subscriber receives the story
			# @story.send
			render json: @story
		else
			render nothing: true, status: 404
		end
	end

	private
		def find_story
			begin
				@story = Api::Story.find params[:id]
				if not current_user.can_access? @story
					render nothing: true, status: :not_found
				end
			rescue ActiveRecord::RecordNotFound
				render nothing: true, status: :not_found
			end
		end

		def rooms_param
			params.require(:story).permit(:rooms)
		end

		def story_params
			params.require(:story).permit(:title, :page_count, :published, :candidate, :story_type, :pages)
		end
end