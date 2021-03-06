require 'rails_helper'

describe 'Story API' do

	before :each do |example|

		@leo = FactoryGirl.create :user, username: "leo"
		@glenn = FactoryGirl.create :user, username: "glenn"
		@olly = FactoryGirl.create :user, username: "olly"
		@thib = FactoryGirl.create :user, username: "thib"

	    unless example.metadata[:skip_before]
			@story = FactoryGirl.create :story, user_id:@glenn.id, :title => 'Go in spain!'

			@leoStory = FactoryGirl.create :story, user_id:@leo.id, :title => 'Je code beaucoup!'
			@leoStory.receivers << @glenn;
			@leoStory.receivers << @olly

			@leoStorySec = FactoryGirl.create :story, user_id:@leo.id, :title => 'Moi qui fait du rails!'
			@leoStorySec.receivers << @glenn
	    end
	end
	

	describe 'POST /users/:id/stories' do
		it 'should create a story' , skip_before: true do

			story_params = {
				:story => {
					:user_id => @glenn.id,
					:title => 'costa rica !'
				}
			}.to_json

			post api("/users/#{@glenn.id}/stories"), story_params, api_headers(token: @glenn.token)

			expect(response.status).to eq 201

			sj = JSON.parse(response.body)
			expect(sj['title']).to eq 'costa rica !'

			s = Api::Story.first
			s.receivers << @leo;

			expect(s.receivers.count).to eq 1	
			expect(s.receivers.first.username).to eq "leo"	
		end

		it 'should create a story with 3 pages' , skip_before: true do

			story_params = {
				:story => {
					:user_id => @glenn.id,
					:title => 'cuba libre !',
					:page_count => 3,
				}
			}.to_json

			post api("/users/#{@glenn.id}/stories"), story_params, api_headers(token: @glenn.token)
			
			expect(response.status).to eq 201

			sj = JSON.parse(response.body)
			expect(sj['pages'].count).to eq 3
		end

		it 'should create story in 2 rooms', skip_before: true do
			@fableRoom = FactoryGirl.create :room, owner_id: @leo.id, name: 'Fables'
			@syrupsRoom = FactoryGirl.create :room, owner_id: @glenn.id, name: 'Syrups'

			@fableRoom.add_user @olly
			@syrupsRoom.add_user @olly

			story_params = {
				:story => {
					:title => 'cuba libre !',
					:page_count => 3,
					:rooms => [@fableRoom.id, @syrupsRoom.id],
					:tag => 'cocktails'
				}
			}.to_json

			post api("/users/#{@olly.id}/stories"), story_params, api_headers(token: @olly.token)

			expect(response.status).to eq 201

			@story = Api::Story.take

			expect(@story.tag).to eq 'cocktails'

			expect(@fableRoom.stories.include?(@story)).to eq true
			expect(@syrupsRoom.stories.include?(@story)).to eq true

		end

		it 'should not create a story in a room I\'m not in' do
			@fableRoom = FactoryGirl.create :room, owner_id: @leo.id, name: 'Fables'

			# Olly is not in fableRoom
			expect(@olly.rooms.include?(@fableRoom)).to eq false

			story_params = {
				:story => {
					:title => 'cuba libre !',
					:page_count => 3,
					:rooms => [@fableRoom.id]
				}
			}.to_json

			post api("/users/#{@olly.id}/stories"), story_params, api_headers(token: @olly.token)

			expect(response.status).to eq 404
		end
	end

	describe 'GET /stories/:id' do

		it 'should return the story requested by the owner' do

			s = FactoryGirl.create :story, user_id:@leo.id
			
			get api("/stories/#{s.id}"), {}, api_headers(token: @leo.token)

			expect(response.status).to eq 200

			sj = JSON.parse(response.body)

			expect(sj['user_id']).to eq @leo.id
		end

		it 'should return the story requested by the receiver' do

			get api("/stories/#{@leoStory.id}"), {}, api_headers(token: @olly.token)

			s = Api::Story.find @leoStory.id

			expect(response.status).to eq 200
			expect(s.receivers.length).to eq 2
		end


		it 'should return response status not found' do

			@thib = FactoryGirl.create :user, username: "thib"
			@glenn = FactoryGirl.create :user, username: "glenn"
			
			s = FactoryGirl.create :story, user_id:@glenn.id
			
			get api("/stories/#{s.id}"), {}, api_headers(token: @thib.token)

			expect(response.status).to eq 404
		end
	end

	describe 'PUT /stories/:id' do
		it 'should update the story requested by the user if has acces to it' do
			
			story_params = {
				:story => {
					:title => 'Go latina !'
				}
			}.to_json

			put api("/stories/#{@story.id}"), story_params, api_headers(token: @glenn.token)

			expect(response.status).to eq 200

			@story.reload
			expect(@story.title).to eq 'Go latina !'
			
		end

		it 'should not update the story and  throw 404' do
			thib = FactoryGirl.create :user, username: "thib"
			glenn = FactoryGirl.create :user, username: "glenn"
			s = FactoryGirl.create :story, user_id:glenn.id
			title = s.title

			s.receivers << thib # Even a receiver should not be allowed to update, ONLY the owner

			story_params = {
				:story => {
					:title => 'Go latina !'
				}
			}.to_json

			put api("/stories/#{s.id}"), story_params, api_headers(token: thib.token)

			s.reload

			expect(response.status).to eq 404
			expect(s.title).to eq title
		end
	end

	describe 'GET /users/:id/stories/created' do
		it 'should return a list of created stories by leo' do
			get api("/users/#{@leo.id}/stories/created"), {}, api_headers(token: @leo.token)

			expect(response.status).to eq 200

			stories = JSON.parse(response.body)
			expect(stories.length).to eq 2	
		end

		it 'should throw 404 for glenn' do
			get api("/users/#{@leo.id}/stories/created"), {}, api_headers(token: @glenn.token)

			expect(response.status).to eq 404
		end
	end

	describe 'GET /users/:id/stories/received' do
		it 'should return a list of received stories' do
			get api("/users/#{@glenn.id}/stories/received"), {}, api_headers(token: @glenn.token)

			stories = JSON.parse(response.body)

			expect(stories.length).to eq 2	
		end

		it 'should throw 404 for glenn' do
			get api("/users/#{@leo.id}/stories/received"), {}, api_headers(token: @glenn.token)

			expect(response.status).to eq 404
		end
	end

	describe 'DELETE /stories/:id' do
		it 'should delete the story requested by the user if has acces to it' do

			s = FactoryGirl.create :story, user_id:@glenn.id

			delete api("/stories/#{s.id}"), {}, api_headers(token: @glenn.token)

			expect(response.status).to eq 200
		end

		it 'should not delete the story and return 404' do

			s = FactoryGirl.create :story, user_id:@glenn.id

			s.receivers << @thib # Even a receiver should not be allowed to delete, ONLY the owner

			delete api("/stories/#{s.id}"), {}, api_headers(token: @thib.token)

			expect(response.status).to eq 404
		end
	end
end