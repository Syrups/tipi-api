class Api::MediaController < ApiController
	before_filter :authenticate_request

	api!
	def create

		original_filename = params[:file].original_filename
		rand = SecureRandom.hex
		name = Digest::SHA2.new(256).hexdigest(original_filename + rand) + '.jpg'

		# Upload to S3
		obj = ::Storages3.bucket('tipi-media').object(name)
		obj.upload_file(params[:file], acl:'public-read')

    # directory = "#{::Rails.root}/public/uploads/media"
    # path = File.join(directory, name)

    # File.open(path, "wb") { |f| f.write(params[:file].read) }

    @page = Api::Page.find params[:page_id]
    @media = @page.create_media!(file: obj.public_url)
    
		if @page.save
			render json: @page.to_json(:include => [ :media ]), status: :created
		else
			render nothing: true, status: :bad_request
		end
	end

	private
		def media_params
			params.require(:media).permit(:file)
		end
end
