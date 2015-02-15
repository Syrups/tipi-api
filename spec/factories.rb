FactoryGirl.define do
	factory :user, class: Api::User do
		username 'leoht'
		salt { SecureRandom.hex }
		password { Security.hash_password('toto13', salt) }
		token { Security.generate_token('leoht') }
	end

	factory :another_user, class: Api::User do
		username 'glenn'
		token 'KJHQSHKLFJQHSFHqjhsfkjhqsjfk'
		password 'google'
	end
end