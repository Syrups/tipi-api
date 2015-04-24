require 'aws-sdk'

class Storage
	cattr_accessor :s3

	def self.connect(access_key_id, access_key_secret, region)
		@@s3 = Aws::S3::Resource.new(
		  credentials: Aws::Credentials.new(access_key_id, access_key_secret),
		  region: region
		)
	end
end
