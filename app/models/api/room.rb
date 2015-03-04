class Api::Room < ActiveRecord::Base
	has_and_belongs_to_many :stories
	has_and_belongs_to_many :users
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

end
