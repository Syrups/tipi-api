require 'securerandom'

class Api::StoriesController < ApiController
	api!
	def create
		story = story_params

		#@user = Api::User.find story[:user_id]

		#if @user.present?
	  	 	#render nothing: true, status: :conflict 
	 	#else

		@story = Api::Story.new(user_id: story[:user_id], title: story[:title])

		if @story.save
			render json: @story, status: :created
		else
			render nothing: true, status: :bad_request
		end
	end


	def story_params

		puts params

		params.require(:story).permit(:user_id, :title)
    end
end