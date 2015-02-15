require 'rails_helper'

describe 'Subscription API' do

	before :each do
		@leo = FactoryGirl.create :user
		@glenn = FactoryGirl.create :another_user
	end

	describe 'POST /users/:id/subscriptions' do
		it 'should send an subscription invitation to glenn' do
			post api("/users/#{@glenn.id}/subscriptions"), {
				:subscription => { :active => false }
			}.to_json, api_headers(token: @leo.token)

			expect(@glenn.invitations.length).to eq 1
		end
	end

	describe 'PUT /subscriptions/:id' do
		it 'should subscribe to this user on invitation' do
			@leo.invite @glenn
			s = Api::Subscribtion.take

			put api("/subscriptions/#{s.id}"), {
				subscription: { active: true }
			}.to_json, api_headers(token: @glenn.token)

			expect(@glenn.subscribed.length).to eq 1
			expect(@leo.subscribers.length).to eq 1
		end

		it 'should disable subscription' do
			@glenn.subscribe_to @leo
			s = Api::Subscribtion.take

			put api("/subscriptions/#{s.id}"), {
				subscription: { active: false }
			}.to_json, api_headers(token: @glenn.token)

			expect(@glenn.subscribed.length).to eq 0
			expect(@leo.subscribers.length).to eq 0
		end

		it 'should not update the subscription of another user' do
			@glenn.subscribe_to @leo
			s = Api::Subscribtion.take

			put api("/subscriptions/#{s.id}"), {
				subscription: { active: false }
			}.to_json, api_headers(token: @leo.token)

			expect(response.status).to eq 404
		end
	end

	describe 'GET /users/:id/subscribers' do
		it 'should list subscribers' do
			@glenn.subscribe_to @leo

			get api("/users/#{@leo.id}/subscribers"), {}, api_headers(token: @leo.token)

			expected_response = [
				@glenn
			].to_json

			expect(response.status).to eq 200
			expect(response.body).to eq expected_response
		end

		it 'should not list subscribers of another user' do
			@glenn.subscribe_to @leo

			get api("/users/#{@leo.id}/subscribers"), {}, api_headers(token: @glenn.token)

			expect(response.status).to eq 404
		end
	end

	describe 'GET /users/:id/subscribed' do
		it 'should list subscribed users' do
			@glenn.subscribe_to @leo

			get api("/users/#{@glenn.id}/subscribed"), {}, api_headers(token: @glenn.token)

			expected_response = [
				@leo
			].to_json

			expect(response.status).to eq 200
			expect(response.body).to eq expected_response
		end

		it 'should not list subscribed users of another user' do
			@glenn.subscribe_to @leo

			get api("/users/#{@glenn.id}/subscribed"), {}, api_headers(token: @leo.token)

			expect(response.status).to eq 404
		end
	end

	describe 'GET /users/:id/invitations' do
		it 'should list invitations to subscribe' do
			@leo.invite @glenn

			get api("/users/#{@glenn.id}/invitations"), {}, api_headers(token: @glenn.token)

			expect(response.status).to eq 200
		end

		it 'should not list invitations desinated to another user' do
			@leo.invite @glenn

			get api("/users/#{@glenn.id}/invitations"), {}, api_headers(token: @leo.token)

			expect(response.status).to eq 404
		end
	end
end