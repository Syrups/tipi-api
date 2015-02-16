class Api::CommentsController < ApiController
	before_filter :authenticate_request
	before_filter :check_access

	def create
		@comment = Api::Comment.create!(comment_params)

		render json: @comment, status: :created
	end

	private

	def check_access
		if params[:page_id].present?
			begin
				@page = Api::Page.find(params[:page_id])
				if not @page.story.receivers.include? current_user
					render nothing: true, status: :not_found
				end
			rescue ActiveRecord::RecordNotFound
				render nothing: true, status: :not_found
			end
		end
	end

	def comment_params
		params.require(:comment).permit(:audio_id)
	end
end