FactoryGirl.define do
	factory :user, class: Api::User do
		username 'leoht'
		token 'jkhsdhfshdfsd786768687dsfsdf'
		password 'toto13'
	end

	factory :story, class: Api::Story do
		user_id 'leoht'
		title 'jkhsdhfshdfsd786768687dsfsdf'
	end
end