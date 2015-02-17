class Api::Story < ActiveRecord::Base
	belongs_to :user, inverse_of: :stories
	has_many :receivers, through: :receptions, foreign_key: 'receiver_id'
	has_many :receptions
	has_many :pages, inverse_of: :story

	def is_owner?(owner)
		owner.id == user.id
	end

	def send_to_subscribers
		user.subscribers.each do |sub|
			receivers << sub
		end

		save!
	end
end
