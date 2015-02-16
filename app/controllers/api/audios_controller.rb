class Api::AudiosController < ApiController

	api!
	def create
		name = params[:audio][:file].original_filename
	    directory = "#{::Rails.root}/spec/fixtures/output"
	    path = File.join(directory, name)

	    File.open(path, "wb") { |f| f.write(params[:audio][:file].read) }

	    @page = Api::Page.find params[:page_id]
	    @audio =  Api::Audio.new(file: "#{::Rails.root}/spec/fixtures/output/#{name}")

	    @page.audio = @audio 
	    
		if @page.save
			puts  @page.audio.inspect
			render json: @page, status: :created
		else
			render nothing: true, status: :bad_request
		end
	end
end