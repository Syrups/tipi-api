FactoryGirl.define do

	factory :user, class: Api::User do
		username 'leoht'
		salt { SecureRandom.hex }
		password { Security.hash_password('toto13', salt) }
		token { Security.generate_token('leoht') }
	end

	factory :page, class: Api::Page do
		position 1		
	end

	factory :story, class: Api::Story do
		user_id 'leoht'
		title 'jkhsdhfshdfsd786768687dsfsdf'
		factory :story_with_receivers do
			after_create do |story|
				FactoryGirl.create(:user, story: story)
			end
		end

		factory :story_with_receivers_and_pages do
			after_create do |story|
				# FactoryGirl.create(:user).stories << story
				FactoryGirl.create(:page, story_id: story.id)
			end
		end
	end

	factory :comment, class: Api::Comment do
	end

	factory :another_user, class: Api::User do
		username 'glenn'
		token 'KJHQSHKLFJQHSFHqjhsfkjhqsjfk'
		password 'google'
	end
end