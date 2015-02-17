class Api::Media < ActiveRecord::Base
	belongs_to :page, inverse_of: :media
end
