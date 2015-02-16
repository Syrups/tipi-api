require 'securerandom'

class Api::StoriesController < ApiController
	before_filter :authenticate_request
	before_filter :find_story, except: :create

	api!
	def create
		story = story_params

		@user = Api::User.find story[:user_id]

		if @user.id == current_user.id
			@story = Api::Story.new(user_id: story[:user_id], title: story[:title])

			if(story.has_key?(:page_number))
				page_number = Integer(story[:page_number])
				page_number.times do |i|
					@story.pages << Api::Page.new();
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

		@story = Api::Story.find params[:id]
		
		if @current_user.id == @story.user_id
			render json: @story
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
			render json: @story
		else
			render nothing: true, status: 404
		end
	end

	private
		def find_story
			begin
				@story = Api::Story.find params[:id]
			rescue ActiveRecord::RecordNotFound
				render nothing: true, status: :not_found
			end

			render nothing: true, status: :not_found unless current_user.can_access? @story
		end

		def story_params
			params.require(:story).permit(:user_id, :title, :page_number)
		end
end