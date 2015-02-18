FactoryGirl.define do  factory :api_user_device, :class => 'Api::UserDevice' do
    token "MyString"
user nil
platform "MyString"
  end
 

	factory :user, class: Api::User do
		username 'leoht'
		salt { SecureRandom.hex }
		password { Security.hash_password('toto13', salt) }
		token { Security.generate_token(username) }
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

	factory :audio, class: Api::Audio do
		file 'sample.m4a'
	end

	factory :another_user, class: Api::User do
		username 'glenn'
		token 'KJHQSHKLFJQHSFHqjhsfkjhqsjfk'
		password 'google'
	end

	factory :public_user, class: Api::User do
		username 'Radio 121'
		token '87987sdjghsdjgkh786786786YHshdfhsiudfh'
		password 'radio'
		account_type 'public'
	end
end