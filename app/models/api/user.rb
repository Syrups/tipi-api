class Api::User < ActiveRecord::Base

	# Subscriptions

	has_many :subscribtions, -> { where "active = true"}
	has_many :subscribers, through: :subscribtions
	has_many :inverse_subscribtions, -> { where "active = true" }, class_name: 'Api::Subscribtion', foreign_key: 'subscriber_id' 
	has_many :subscribed, through: :inverse_subscribtions, :source => :user
	has_many :invitations, -> { where "active = false" }, class_name: 'Api::Subscribtion', foreign_key: 'subscriber_id'
	has_many :inviters, through: :invitations, :source => :user
	has_many :inverse_invitations, -> { where "active = false" }, class_name: 'Api::Subscribtion', foreign_key: 'user_id'
	has_many :invitees, through: :inverse_invitations, :source => :subscriber

	# Stories and comments
	has_many :stories, inverse_of: :user
	has_many :comments, inverse_of: :user
	has_many :received_stories, through: :receptions, :source => :story
	has_many :receptions, foreign_key: 'receiver_id'

	# Friendships and requests
	has_many :outcoming_requests, -> { where "active = false" }, class_name: 'Api::Friendship', foreign_key: 'user_id'
	has_many :requested, through: :outcoming_requests, source: :friend
	has_many :incoming_requests, -> { where "active = false" }, class_name: 'Api::Friendship', foreign_key: 'friend_id'
	has_many :requesting, through: :incoming_requests, source: :user

	has_many :outcoming_friendships, -> { where "active = true" }, class_name: 'Api::Friendship', foreign_key: 'user_id'
	has_many :outcoming_friends, through: :outcoming_friendships, source: :friend
	has_many :incoming_friendships, -> { where "active = true" }, class_name: 'Api::Friendship', foreign_key: 'friend_id'
	has_many :incoming_friends, through: :incoming_friendships, source: :user

	# Rooms

	has_and_belongs_to_many :rooms
	has_many :owned_rooms, class_name: 'Api::Room', foreign_key: 'owner_id'

	# Audio biography/avatar
	has_one :audio, inverse_of: :user

	# Devices
	has_many :apple_devices, -> { where "platform = 'ios'" }, class_name: 'Api::UserDevice'
	has_many :android_devices, -> { where "platform = 'android'" }, class_name: 'Api::UserDevice'

	scope :public_people, -> { where "account_type = 'public'" }

	def invite(invitee)
		invitee.invitations.create(user_id: id, subscriber_id: invitee.id, active: 0)
	end

	# Create an outcoming friendship
	# with inactive=1
	def add_friend(friend)
		Api::Friendship.create(user_id: id, friend_id: friend.id, active: false)
	end

	# Accept an incoming friendship
	def accept_friend(friend)
		relation = incoming_requests.where(['friend_id = ? and user_id = ?', id, friend.id]).first
		relation.update!(active: true)
	end

	# All incoming and outcoming friends
	def friends
		incoming_friends | outcoming_friends
	end

	# All incoming and outcoming friends
	def all_rooms
		owned_rooms | rooms
	end

	def subscribe_to(user)
		self.inverse_subscribtions.create(user_id: user.id, subscriber_id: id, active: 1)
	end

	def can_access?(story)
		# A user has read access to a story if :
		# - He received it
		# - He created it
		# - It is a public story from a broadcaster
		story.receivers.include? self or story.user.id == id or story.is_public?
	end

	def can_access_room?(room)
		# A user has read access to a story if :
		# - He received it
		# - He created it
		# - It is a public story from a broadcaster
		room.users.include? self or room.is_owner? self
		#or room.is_public?
	end

	def is_public?
		account_type == 'public'
	end

	def self.search(query)
		where('username LIKE :username', username: query)
	end

	# JSON serialization
	def json_with_audio_and_stories
		to_json(:include => [:audio, :stories], :except => [:password, :salt, :token, :audio_id])
	end
end
