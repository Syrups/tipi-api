require 'rails_helper'

describe Api::Story do
	before :each do
		@leo = Api::User.create(username: 'leoht')
		@glenn = Api::User.create(username: 'glenn')
	end

	it 'should be owner' do
		story = @leo.stories.create!(title: 'My story')

		expect(story.is_owner?(@leo)).to eq true
	end
end