FactoryGirl.define do
	factory :user, class: Api::User do
		username 'leoht'
		token 'jkhsdhfshdfsd786768687dsfsdf'
		password 'toto13'
	end

	factory :another_user, class: Api::User do
		username 'glenn'
		token 'KJHQSHKLFJQHSFHqjhsfkjhqsjfk'
		password 'google'
	end
end