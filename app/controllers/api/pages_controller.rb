class Api::PagesController < ApiController
	before_filter :authenticate_request

	api!
	def create
		@story = Api::Story.find params[:story_id]
		@page = @story.pages.create!(page_params)

		if @story.save
			render json: @page, status: :created
		else
			render nothing: true, status: :bad_request
		end
	end

	private
		def page_params
			params.require(:page).permit(:position, :duration, :has_only_sound)
		end
end