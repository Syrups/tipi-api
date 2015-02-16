class Api::Comment < ActiveRecord::Base
	has_one :audio
end
