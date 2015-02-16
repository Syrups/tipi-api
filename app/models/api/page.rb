class Api::Page < ActiveRecord::Base
	belongs_to :story
	has_one :audio
	has_many :comments
end
