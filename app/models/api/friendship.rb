class Api::Friendship < ActiveRecord::Base
	belongs_to :user
	belongs_to :friend, class_name: 'Api::User'
end
