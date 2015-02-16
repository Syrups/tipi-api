class Api::CommentsController < ApiController
	before_filter :authenticate_request
	before_filter :find_page, only: [:index, :create]
	before_filter :find_comment, only: [:show, :destroy]
	before_filter :check_access

	api!
	def index
		render json: @page.comments, status: :ok
	end

	api!
	def create
		@comment = @page.comments.create!(comment_params)
		@comment.create_audio!(audio_params)

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
					if not current_user.can_access? @page.story
						render nothing: true, status: :not_found
					end
				rescue ActiveRecord::RecordNotFound
					render nothing: true, status: :not_found
				end
			else
				begin
					if not current_user.can_access? @comment.page.story
						render nothing: true, status: :not_found
					end
				rescue ActiveRecord::RecordNotFound
					render nothing: true, status: :not_found
				end
			end
		end

		def comment_params
			params.require(:comment).permit()
		end

		def audio_params
			params.require(:comment).require(:audio).permit(:file)
		end
end