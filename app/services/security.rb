class Security
	def self.hash_password(plain, salt)
		Digest::SHA2.new(256).hexdigest(plain + ':' + salt)
	end

	def self.generate_token(username)
		Digest::SHA2.new(256).hexdigest(username)
	end
end