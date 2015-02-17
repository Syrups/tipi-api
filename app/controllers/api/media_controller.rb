class Api::MediaController < ApiController
	before_filter :authenticate_request

	api!
	def create
		name = media_params[:file].original_filename
    directory = "#{::Rails.root}/spec/fixtures/output"
    path = File.join(directory, name)

    File.open(path, "wb") { |f| f.write(media_params[:file].read) }

    @page = Api::Page.find params[:page_id]
    @media = @page.create_media!(file: "#{::Rails.root}/spec/fixtures/output/#{name}")
    
		if @page.save
			render json: @page, status: :created
		else
			render nothing: true, status: :bad_request
		end
	end

	private
		def media_params
			params.require(:media).permit(:file)
		end
end
