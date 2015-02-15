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
		# factory :story_with_receivers, :parent => :receivers do
		# 	after_create do |venue|
		# 		FactoryGirl.create(:receivers, :story => story)
		# 	end
		# end

		factory :story_with_receivers do
			after_create do |story|
				FactoryGirl.create(:user, story: story)
			end
		end

		# factory :story_with_receivers do
		# 	transient do
		# 		posts_count 5
		# 	end
		# 	after(:create) do |user, evaluator|
		# 		create_list(:receivers, evaluator.posts_count, user: user)
		# 	end
		# end
	end

	factory :another_user, class: Api::User do
		username 'glenn'
		token 'KJHQSHKLFJQHSFHqjhsfkjhqsjfk'
		password 'google'
	end
end