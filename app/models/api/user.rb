class Api::User < ActiveRecord::Base
	has_many :subscribtions, -> { where "active = true"}
	has_many :subscribers, through: :subscribtions
	has_many :inverse_subscribtions, -> { where "active = true" }, class_name: 'Api::Subscribtion', foreign_key: 'subscriber_id' 
	has_many :subscribed, through: :inverse_subscribtions, :source => :user
	has_many :invitations, -> { where "active = false" }, class_name: 'Api::Subscribtion', foreign_key: 'subscriber_id'
	has_many :inviters, through: :invitations, :source => :user
	has_many :inverse_invitations, -> { where "active = false" }, class_name: 'Api::Subscribtion', foreign_key: 'user_id'
	has_many :invitees, through: :inverse_invitations, :source => :subscriber
	has_many :stories, inverse_of: :user
	has_many :comments, inverse_of: :user

	has_many :received_stories, through: :receptions, :source => :receiver
	has_many :receptions, foreign_key: 'receiver_id'

	has_one :audio, inverse_of: :user

	scope :public_people, -> { where "account_type = public" }

	def invite(invitee)
		invitee.invitations.create(user_id: id, subscriber_id: invitee.id, active: 0)
	end

	def subscribe_to(user)
		self.inverse_subscribtions.create(user_id: user.id, subscriber_id: id, active: 1)
	end

	def can_access?(story)
		story.receivers.include? self or story.user.id == id
	end

	def is_public?
		account_type == 'public'
	end

	def self.search(query)
		where('username LIKE :username', username: query)
	end
end
