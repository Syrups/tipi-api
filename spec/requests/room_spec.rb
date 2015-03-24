require 'rails_helper'

describe 'Rooms API' do

	before :each do |example|
		@leo = FactoryGirl.create :user, username: "leo"

		@olly = FactoryGirl.create :user, username: "olly"
		@thib = FactoryGirl.create :user, username: "thib"

		@glenn = FactoryGirl.create :user, username: "glenn"

		@glenn.add_friend(@leo)
		@glenn.add_friend(@olly)

		@leo.accept_friend(@glenn)
		@olly.accept_friend(@glenn)

		@glennStory = FactoryGirl.create :story, user_id:@glenn.id, :title => 'Go in spain!'
		@leoStory = FactoryGirl.create :story, user_id:@leo.id, :title => 'Je code beaucoup!', :tag => 'LosAngeles'

		 unless example.metadata[:skip_before]
			@glennRoom = FactoryGirl.create :room, owner_id:@glenn.id, :name => 'Team Fable powa'

			@leoRoom = FactoryGirl.create :room, owner_id:@leo.id, :name => 'Team Syrups'
			@leoRoom.add_user @glenn
			@leoRoom.stories << @glennStory
			@leoRoom.stories << @leoStory
	    end
	end

	describe 'POST /users/:id/rooms' do
		it 'should create a room', skip_before: true do
			room_params = {
				:room => {
					:name => 'Team Fables'
				}
			}.to_json

			post api("/users/#{@glenn.id}/rooms"), room_params, api_headers(token: @glenn.token)

			expect(response.status).to eq 201

			r = Api::Room.first

			expect(r.owner_id).to eq @glenn.id	
			expect(r.name).to eq "Team Fables"
		end

		it 'should create room and invite users', skip_before: true do
			room_params = {
				:room => {
					:name => 'Team Fables assemblee',
					:users =>  [@leo.id, @olly.id, @thib.id]
				}
			}.to_json

			post api("/users/#{@glenn.id}/rooms"), room_params, api_headers(token: @glenn.token)

			expect(response.status).to eq 201

			r = Api::Room.first

			expect(r.owner_id).to eq @glenn.id	
			expect(r.name).to eq "Team Fables assemblee"
			expect(r.participants.count).to eq 1

			requests = Api::Presence.where(['room_id = ?', r.id])

			expect(requests.count).to eq 3
			expect(r.pending_users.count).to eq 3

			expect(r.pending_users.include?(@leo)).to eq true
			expect(r.pending_users.include?(@olly)).to eq true
			expect(r.pending_users.include?(@thib)).to eq true
		end
	end

	describe 'GET /users/:id/rooms' do
		it 'should list all rooms' do

			get api("/users/#{@glenn.id}/rooms"), {}, api_headers(token: @glenn.token)

			expect(response.status).to eq 200

			rooms = @glenn.all_rooms

			expect(rooms.count).to eq 2
		end
	end

	describe 'GET /rooms/:id/stories' do
		it 'should list all stories in room' do

			get api("/rooms/#{@leoRoom.id}/stories"), {}, api_headers(token: @leo.token)

			expect(response.status).to eq 200

			rJ = JSON.parse(response.body)

			expect(rJ.count).to eq 2
		end

		it 'should filter stories with query tag LosAngeles' do
			
			get api("/rooms/#{@leoRoom.id}/stories/?user=#{@leo.id}"), {}, api_headers(token: @leo.token)

			expect(response.status).to eq 200

			rJ = JSON.parse(response.body)

			expect(rJ.count).to eq 1
		end

		it 'should filter only stories of leo' do

		end
	end

	describe 'POST /rooms/:id/users' do
		it 'should invite user to room' do

			room_params = {
				:room => {
					:users =>  [@leo.id, @olly.id]
				}
			}.to_json

			post api("/rooms/#{@glennRoom.id}/users"), room_params, api_headers(token: @glenn.token)

			expect(response.status).to eq 201

			r = Api::Room.find @glennRoom.id

			expect(r.pending_users.count).to eq 2
			expect(@leo.requesting_rooms.include?(r)).to eq true
			expect(@olly.requesting_rooms.include?(r)).to eq true
		end

		it 'should not add if user is not friend' do
			room_params = {
				:room => {
					:users =>  [@thib.id]
				}
			}.to_json

			post api("/rooms/#{@glennRoom.id}/users"), room_params, api_headers(token: @glenn.token)

			r = Api::Room.find @glennRoom.id
			expect(r.users.count).to eq 0
		end
	end

	describe 'GET /rooms/:id/users' do
		it 'shoud list users in room' do
			get api("/rooms/#{@leoRoom.id}/users"), {}, api_headers(token: @leo.token)

			participants = JSON.parse(response.body)

			expect(response.status).to eq 200
			expect(participants.count).to eq 2

		end
	end

	describe 'PUT /rooms/:id' do
		it 'should update room' do 
			room_params = {
				:room => {
					:name =>  'Yop Yop Yup'
				}
			}.to_json

			put api("/rooms/#{@glennRoom.id}"), room_params, api_headers(token: @glenn.token)

			expect(response.status).to eq 200

			r = Api::Room.find @glennRoom.id
			expect(r.name).to eq 'Yop Yop Yup'
		end
	end

	describe 'DELETE /rooms/:id/stories/:story_id' do
		it 'should remove story from room' do
			delete api("/rooms/#{@leoRoom.id}/stories/#{@glennStory.id}"), {}, api_headers(token: @glenn.token)

			expect(response.status).to eq 200

			r = Api::Room.find @leoRoom.id

			expect(r.stories.count).to eq 1
		end

		it 'should not remove story from room' do
			delete api("/rooms/#{@leoRoom.id}/stories/#{@glennStory.id}"), {}, api_headers(token: @leo.token)

			expect(response.status).to eq 404

			r = Api::Room.find @leoRoom.id
			expect(r.stories.count).to eq 2

			s = Api::Story.find @glennStory.id
			expect(s.title).to eq 'Go in spain!'

		end
	end

	describe 'DELETE /rooms/:id/users/:user_id' do
		it 'should remove user from room' do
			delete api("/rooms/#{@leoRoom.id}/users/#{@glenn.id}"), {}, api_headers(token: @glenn.token)

			expect(response.status).to eq 200

			r = Api::Room.find @leoRoom.id

			expect(r.participants.count).to eq 1
		end

		it 'should not remove user from room' do
			delete api("/rooms/#{@leoRoom.id}/users/#{@glenn.id}"), {}, api_headers(token: @leo.token)

			expect(response.status).to eq 404

			r = Api::Room.find @leoRoom.id
			expect(r.participants.count).to eq 2
		end
	end

	describe 'DELETE /rooms/:id' do
		it 'should be destroyed by owner' do
			delete api("/rooms/#{@leoRoom.id}"), {}, api_headers(token: @leo.token)
			expect(response.status).to eq 200
		end

		it 'should not be destroyed ' do
			delete api("/rooms/#{@leoRoom.id}"), {}, api_headers(token: @glenn.token)
			expect(response.status).to eq 404
		end
	end

end