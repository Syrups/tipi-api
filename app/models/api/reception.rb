class Api::Reception < ActiveRecord::Base
	belongs_to :story
	belongs_to :receiver, class_name: 'Api::User'
end
