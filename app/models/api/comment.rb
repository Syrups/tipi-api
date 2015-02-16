class Api::Comment < ActiveRecord::Base
	has_one :audio
	belongs_to :page
	belongs_to :user
end
