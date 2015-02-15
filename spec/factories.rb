FactoryGirl.define do
	factory :user, class: Api::User do
		username 'leoht'
		salt { SecureRandom.hex }
		password { Security.hash_password('toto13', salt) }
		token { Security.generate_token('leoht') }
	end


	factory :story, class: Api::Story do
		user_id 'leoht'
		title 'jkhsdhfshdfsd786768687dsfsdf'
		factory :story_with_receivers do
			after_create do |story|
				FactoryGirl.create(:user, story: story)
			end
		end
	end

	factory :another_user, class: Api::User do
		username 'glenn'
		token 'KJHQSHKLFJQHSFHqjhsfkjhqsjfk'
		password 'google'
	end
end