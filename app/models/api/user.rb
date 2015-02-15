class Api::User < ActiveRecord::Base
	has_many :subscribtions
	has_many :subscribers, through: :subscribtions
	has_many :inverse_subscribtions, -> { where "active = true" }, class_name: 'Api::Subscribtion', foreign_key: 'subscriber_id' 
	has_many :subscribed, through: :inverse_subscribtions, :source => :user
	has_many :invitations, -> { where "active = false" }, class_name: 'Api::Subscribtion', foreign_key: 'subscriber_id'
	has_many :inviters, through: :invitations, :source => :user
	has_many :stories

	def invite(invitee)
		invitee.invitations.create(user_id: id, active: false)
	end
end
