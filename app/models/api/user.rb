class Api::User < ActiveRecord::Base
	has_many :subscribtions
	has_many :subscribers, through: :subscribtions
	has_many :inverse_subscribtions, class_name: 'Api::Subscribtion', foreign_key: 'subscriber_id'
	has_many :subscribed, through: :inverse_subscribtions, :source => :user
end
