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
			#@page = FactoryGirl.create :page
			#@story.pages << @page
			#story.receivers << @leo
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


		it 'should return response status 401 unauthorized' do

			@thib = FactoryGirl.create :user, username: "thib"
			@glenn = FactoryGirl.create :user, username: "glenn"
			
			s = FactoryGirl.create :story, user_id:@glenn.id
			
			get api("/stories/#{s.id}"), {}, api_headers(token: @thib.token)

			expect(response.status).to eq 401
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

		it 'should update the throw 404' do
			
			story_params = {
				:story => {
					:title => 'Go latina !'
				}
			}.to_json

			put api("/stories/#{@story.id}"), story_params, api_headers(token: @leo.token)

			expect(response.status).to eq 404			
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
			puts stories
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

			delete api("/stories/#{s.id}"), {}, api_headers(token: @thib.token)

			expect(response.status).to eq 404
		end
	end
end