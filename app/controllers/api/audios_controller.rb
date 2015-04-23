class Api::AudiosController < ApiController
	before_filter :authenticate_request

	api!
	def create
		
		original_filename = params[:file].original_filename
		rand = SecureRandom.hex
		name = Digest::SHA2.new(256).hexdigest(original_filename + rand) + '.m4a'

		# Upload to S3
		obj = s3.bucket('tipi-media').object(name)
		obj.upload_file(params[:file].tempfile.path, acl:'public-read')


    # directory = "#{::Rails.root}/public/uploads/audio"
	   #  path = File.join(directory, name)

	   #  File.open(path, "wb") { |f| f.write(params[:file].read) }

	    @page = Api::Page.find params[:page_id]
	    @audio = @page.create_audio!(file: obj.public_url)
	    
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