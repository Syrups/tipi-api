class Api::Audio < ActiveRecord::Base
	belongs_to :comment, inverse_of: :audio
	belongs_to :page, inverse_of: :audio
	belongs_to :user, inverse_of: :audio
end
