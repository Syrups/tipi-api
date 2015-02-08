class Api::Subscribtion < ActiveRecord::Base
	belongs_to :user
	belongs_to :subscriber, class_name: 'Api::User'
end
