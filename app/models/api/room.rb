class Api::Room < ActiveRecord::Base
	has_and_belongs_to_many :stories
	
	has_many :accepted_presences, -> { where "active = true" }, class_name: 'Api::Presence', foreign_key: 'room_id'
	has_many :pending_presences, -> { where "active = false" }, class_name: 'Api::Presence', foreign_key: 'room_id'

	has_many :users, through: :accepted_presences, source: :user
	has_many :pending_users, through: :pending_presences, source: :user

	belongs_to :owner, class_name: 'Api::User'

	def stories_with_tag(tag)
		#self.stories.where(tag: user.id, subscriber_id: id, active: 1)
		#with_tag = stories.where(['tag like ?', tag])
		stories.where('tag LIKE :tag', tag: tag)
	end

	def stories_of_user(user_id)
		stories.where('user_id = :user_id', user_id: user_id)
	end

	def is_owner?(user)
		owner.id == user.id
	end

	def participants
		users | [owner]
	end

	def invite_user(user)
		Api::Presence.create(user_id: user.id, room_id: id, active: false)
	end

	def add_user(user)
		presence = pending_presences.where(['user_id = ? and room_id = ?', user.id, id]).first

		if presence.present?
			presence.update!(active: true)
		else
			Api::Presence.create(user_id: user.id, room_id: id, active: true)
		end
	end

end
