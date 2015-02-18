class Api::Comment < ActiveRecord::Base
	has_one :audio, inverse_of: :comment
	belongs_to :page, inverse_of: :comments
	belongs_to :user, inverse_of: :comments

	def can_read?(reader)
		reader.can_access? page.story
	end

	def can_touch?(toucher)
		user.id == toucher.id or page.story.is_owner? toucher
	end
end
