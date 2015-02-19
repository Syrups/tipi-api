class Api::Story < ActiveRecord::Base
	belongs_to :user, inverse_of: :stories
	has_many :receivers, through: :receptions, foreign_key: 'receiver_id'
	has_many :receptions
	has_many :pages, inverse_of: :story
	has_and_belongs_to_many :rooms

	def is_owner?(owner)
		owner.id == user.id
	end

	def is_public?
		story_type == 'public'
	end

	def send_to_subscribers
		user.subscribers.each do |sub|
			receivers << sub
		end

		save!
	end

	def json_with_pages
		to_json(:include =>  { :pages => { :include => [:audio, :media] }, :user => {} })
	end

	def can_read?(reader)
		receivers.include? reader or is_owner? reader
	end

	def can_touch(toucher)
		is_owner? reader
	end
end
