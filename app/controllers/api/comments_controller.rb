class Api::CommentsController < ApiController
	before_filter :authenticate_request
	before_filter :check_access
	before_filter :find_page, only: [:index, :create]
	before_filter :find_comment, only: [:show, :destroy]

	api!
	def index
		render json: @page.comments, status: :ok
	end

	api!
	def create
		@comment = @page.comments.create!(comment_params)

		render json: @comment, status: :created
	end

	api!
	def show
		render json: @comment, status: :ok
	end

	api!
	def destroy
		@comment.destroy!

		render nothing: true, status: :ok
	end

	private

		def find_page
			begin
				@page = Api::Page.includes(:comments).find(params[:page_id])
			rescue ActiveRecord::RecordNotFound
				render nothing: true, status: :not_found
			end
		end

		def find_comment
			begin
				@comment = Api::Comment.find(params[:id])
			rescue ActiveRecord::RecordNotFound
				render nothing: true, status: :not_found
			end
		end

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
			else
				begin
					comment = Api::Comment.find(params[:id])
					if not current_user.can_access comment.page.story
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