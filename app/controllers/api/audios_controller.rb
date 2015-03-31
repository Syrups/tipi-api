class Api::AudiosController < ApiController
	before_filter :authenticate_request

	api!
	def create
		
		name = params[:file].original_filename
	    directory = "#{::Rails.root}/spec/fixtures/output"
	    path = File.join(directory, name)

	    File.open(path, "wb") { |f| f.write(params[:file].read) }

	    @page = Api::Page.find params[:page_id]
	    @audio = @page.create_audio!(file: "#{::Rails.root}/spec/fixtures/output/#{name}")
	    
		if @page.save
			render json: @page, status: :created
		else
			render nothing: true, status: :bad_request
		end
	end

	private
		def audio_params
			params.require(:audio).permit(:file)
		end
end