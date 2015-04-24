require 'rails_helper'

describe 'Friends API' do
	before :each do
		@leo = FactoryGirl.create :user
		@glenn = FactoryGirl.create :user, username: 'glenn'
		@olly = FactoryGirl.create :user, username: 'olly'
	end

	describe 'POST /users/:id/friends' do
		it 'should send a friend request' do
			post api("/users/#{@leo.id}/friends"), {
				:friend_id => @glenn.id
			}.to_json, api_headers(token: @leo.token)

			expect(response.status).to eq 201
			expect(@leo.requested.include?(@glenn)).to eq true
			expect(@glenn.requesting.include?(@leo)).to eq true
		end
	end

	describe 'PUT /users/:id/friends/accept' do
		it 'should accept the friend request' do
			@glenn.add_friend @leo

			put api("/users/#{@leo.id}/friends/accept"), {
				:friend_id => @glenn.id
			}.to_json, api_headers(token: @leo.token)

			expect(response.status).to eq 200
			expect(@leo.friends.include?(@glenn)).to eq true
			expect(@glenn.friends.include?(@leo)).to eq true
		end
	end

	describe 'GET /users/:id/friends' do
		it 'should list friends' do
			@glenn.add_friend @leo
			@leo.accept_friend @glenn

			get api("/users/#{@leo.id}/friends"), {}, api_headers(token: @leo.token)

			expect(response.status).to eq 200
		end
	end

	describe 'GET /users/:id/friends/requests' do
		it 'should list incoming friends requests' do
			@glenn.add_friend @leo

			get api("/users/#{@leo.id}/friends"), {}, api_headers(token: @leo.token)

			expect(response.status).to eq 200
		end
	end

	describe 'DELETE /users/:id/friends' do
		it 'should delete a friendship' do

			@leo.add_friend @glenn
			@glenn.accept_friend @leo

			@glenn.add_friend @olly
			@olly.accept_friend @glenn

			delete api("/users/#{@leo.id}/friends"), {
				:friend_id => @glenn.id
			}.to_json, api_headers(token: @leo.token)

			expect(response.status).to eq 200
			expect(@leo.friends.include?(@glenn)).to eq false
			expect(@glenn.friends.include?(@leo)).to eq false

			delete api("/users/#{@olly.id}/friends"), {
				:friend_id => @glenn.id
			}.to_json, api_headers(token: @olly.token)

			@olly.reload
			@glenn.reload

			expect(response.status).to eq 200
			expect(@olly.friends.include?(@glenn)).to eq false
			expect(@glenn.friends.include?(@olly)).to eq false
		end
	end
end