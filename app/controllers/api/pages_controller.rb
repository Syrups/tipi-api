class Api::PagesController < ApiController

	api!
	def create

		@story = Api::Story.find params[:story_id]
		@page = Api::Page.new()

		@story.pages << @page

		if @story.save && @page.save
			render json: @page, status: :created
		else
			render nothing: true, status: :bad_request
		end
	end
end