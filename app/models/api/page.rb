class Api::Page < ActiveRecord::Base
	belongs_to :story, inverse_of: :pages
	has_one :audio, inverse_of: :audio
	has_many :comments, inverse_of: :page
end
