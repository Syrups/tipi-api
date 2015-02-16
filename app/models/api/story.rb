class Api::Story < ActiveRecord::Base
	belongs_to :user
	has_many :receivers, through: :receptions, foreign_key: 'receiver_id'
	has_many :receptions
	has_many :pages

	def is_owner?(owner)
		owner.id == user.id
	end
end
