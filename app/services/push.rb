class Push

	DEVICE_TYPE_IOS = 'ios'
	DEVICE_TYPE_ANDROID = 'android'

	def self.send_to_many(users, message)
		users.each do |user|
			self.send(user, message)
		end
	end

	def self.send(user, message)
		if user.device_type == DEVICE_TYPE_IOS
			self.send_ios(user, message)
		elsif user.device_type == DEVICE_TYPE_ANDROID
			# android
		end	
	end

	private
		def self.send_ios(user, message)
			note = APNS::Notification.new(user.device_token, :alert => message, :badge => 1, :sound => 'default', :content_available => true)
			APNS.send_notifications [ note ]
		end
end