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
		if params[:file].present?

			# File upload
			original_filename = params[:file].original_filename
			rand = SecureRandom.hex
			name = Digest::SHA2.new(256).hexdigest(original_filename + rand) + '.m4a'

			# Upload to S3
			obj = ::Storage.s3.bucket('tipi-media').object(name)
			obj.upload_file(params[:file], acl:'public-read')

			@comment = @page.comments.create!(timecode: params[:timecode], duration: params[:duration], user_id: current_user.id)
			@comment.create_audio!(file: obj.public_url, duration: params[:duration])

			::Push.send(@page.story.user, current_user.username + " a enregistré un nouveau commentaire sur votre histoire \"" + @page.story.title + "\"")

			render json: @comment, status: :created
		else
			render nothing: true, status: :bad_request
		end
	end

	api!
	def show
		render json: @comment.to_json(:include => [:user]), status: :ok
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