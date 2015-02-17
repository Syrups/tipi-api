class Api::Page < ActiveRecord::Base
	belongs_to :story, inverse_of: :pages
	has_one :audio, inverse_of: :page
	has_one :media, inverse_of: :page
	has_many :comments, inverse_of: :page

	def can_read?(reader)
		reader.can_access? story
	end

	def can_touch?(toucher)
		story.is_owner? toucher
	end
end
