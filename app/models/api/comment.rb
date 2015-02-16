class Api::Comment < ActiveRecord::Base
	has_one :audio, inverse_of: :comment
	belongs_to :page, inverse_of: :comments
	belongs_to :user, inverse_of: :comments
end
