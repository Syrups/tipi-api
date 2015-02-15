require 'rails_helper'

describe 'Story API' do
	describe 'POST /users/:id/stories' do
		it 'should create a story' do
			glenn = FactoryGirl.create :user
			leo = FactoryGirl.create :user

			story_params = {
				:story => {
					:user_id => glenn.id,
					:title => 'costa rica !'
				}
			}.to_json

			post api("/users/#{glenn.id}/stories"), story_params, headers

			expect(response.status).to eq 201
			expect(Api::Story.first.title).to eq 'costa rica !'

			s = Api::Story.first

			s.receivers << leo;
			s.reload!
			
			leo.reload!

			expect(s.receivers.count).to eq 1		
		end
	end

	describe 'GET /stories/:id' do
		it 'should return the story requested by the user if has acces to it'
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