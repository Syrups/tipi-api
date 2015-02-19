require 'rails_helper'

describe Api::User do
	before :each do
		@leo = Api::User.create(username: 'leoht')
		@glenn = Api::User.create(username: 'glenn')
	end

	it 'should invite' do
		@leo.invite @glenn

		expect(@glenn.inviters.length).to eq 1
		expect(@leo.invitees.length).to eq 1
	end

	it 'should subscribe' do
		@glenn.subscribe_to @leo

		expect(@glenn.subscribed.length).to eq 1
		expect(@leo.subscribers.length).to eq 1
	end

	it 'should have access to story' do
		@story = @leo.stories.create(title: 'My story')

		@story.receivers << @glenn

		expect(@leo.can_access?(@story)).to eq true
		expect(@glenn.can_access?(@story)).to eq true
	end

	it 'should have access to public story' do
		@radio = FactoryGirl.create :public_user

		@story = @radio.stories.create!(title: 'Public story', story_type: 'public')

		expect(@leo.can_access?(@story)).to eq true
		expect(@glenn.can_access?(@story)).to eq true
	end

	it 'should send friend request' do
		@leo.add_friend @glenn

		expect(@leo.requested.include?(@glenn)).to eq true
		expect(@glenn.requesting.include?(@leo)).to eq true

	end

	it 'should accept friend request' do
		@leo.add_friend @glenn
		@glenn.accept_friend @leo
		
		expect(@leo.outcoming_friends.include?(@glenn)).to eq true
		expect(@glenn.incoming_friends.include?(@leo)).to eq true
		expect(@leo.requested.length).to eq 0
		expect(@leo.requesting.length).to eq 0
		expect(@leo.friends.include?(@glenn)).to eq true
		expect(@glenn.friends.include?(@leo)).to eq true
	end
end