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
end