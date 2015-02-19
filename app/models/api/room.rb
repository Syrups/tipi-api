class Api::Room < ActiveRecord::Base
	has_and_belongs_to_many :stories
	has_and_belongs_to_many :users
	belongs_to :owner, class_name: 'Api::User'
end
