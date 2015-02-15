require 'rails_helper'

describe 'Story API' do
	describe 'POST /users/:id/stories' do
		it 'should create a story' do
			glenn = FactoryGirl.create :user
			leo = FactoryGirl.create :user, username: "leo"

			story_params = {
				:story => {
					:user_id => glenn.id,
					:title => 'costa rica !'
				}
			}.to_json

			post api("/users/#{glenn.id}/stories"), story_params, api_headers(token: glenn.token)

			expect(response.status).to eq 201
			expect(Api::Story.first.title).to eq 'costa rica !'

			s = Api::Story.first
			s.receivers << leo;

			expect(s.receivers.count).to eq 1	
			expect(s.receivers.first.username).to eq "leo"	
		end
	end

	describe 'GET /stories/:id' do


		it 'should return the story requested by the owner' do

			leo = FactoryGirl.create :user, username: "leo"
			glenn = FactoryGirl.create :user, username: "glenn"
			
			olly = FactoryGirl.create :user, username: "olly"
			thib = FactoryGirl.create :user, username: "thib"

			s = FactoryGirl.create :story, user_id:leo.id
			
			get api("/stories/#{s.id}"), {}, api_headers(token: leo.token)

			sj = JSON.parse(response.body)

			expect(response.status).to eq 200
			expect(sj['user_id']).to eq leo.id
			
		end

		it 'should return the story requested by the receiver' do
			glenn = FactoryGirl.create :user, username: "glenn"
			leo = FactoryGirl.create :user, username: "leo"
			olly = FactoryGirl.create :user, username: "olly"
			thib = FactoryGirl.create :user, username: "thib"

			s = FactoryGirl.create :story, user_id:leo.id
			s.receivers << glenn;
			s.receivers << olly

			get api("/stories/#{s.id}"), {}, api_headers(token: olly.token)

			sj = JSON.parse(response.body)

			expect(response.status).to eq 200
			expect(sj['receivers'].length).to eq 2	
		end


		it 'should return response status 401 unauthorized' do

			thib = FactoryGirl.create :user, username: "thib"
			glenn = FactoryGirl.create :user, username: "glenn"
			
			s = FactoryGirl.create :story, user_id:glenn.id
			
			get api("/stories/#{s.id}"), {}, api_headers(token: thib.token)

			expect(response.status).to eq 401
		end
	end

	describe 'DELETE /stories/:id' do
		it 'should delte the story requested by the user if has acces to it'
	end

	describe 'PUT /stories/:id' do
		it 'should update the story requested by the user if has acces to it'
	end

	describe 'GET /users/:id/stories/created' do
		it 'should return a list of created stories'
	end

	describe 'GET /users/:id/stories/received' do
		it 'should return a list of received stories'
	end
end