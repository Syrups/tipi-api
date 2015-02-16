class Api::Audio < ActiveRecord::Base
	belongs_to :comment
	belongs_to :page
end
