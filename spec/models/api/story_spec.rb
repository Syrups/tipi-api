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

	it 'should send to subscribers' do
		@leo.subscribers << @glenn

		story = @leo.stories.create(title: 'My story')

		story.send_to_subscribers

		@glenn.reload
		story.reload

		expect(@glenn.received_stories.include?(story)).to eq true
		expect(story.receivers.include?(@glenn)).to eq true
	end
end