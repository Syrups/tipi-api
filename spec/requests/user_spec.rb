require 'rails_helper'

describe 'Users API' do

	describe 'POST /users' do
		it 'should create user and respond with json' do
			user_params = {
				:user => {
					:username => 'leoht',
					:password => 'toto13'
				}
			}.to_json

			post api('/users'), user_params, api_headers

			expect(response.status).to eq 201
			expect(Api::User.first.username).to eq 'leoht'
		end

		it 'should respond with 409 conflict' do
			u = FactoryGirl.create :user

			user_params = {
				:user => {
					:username => u.username,
					:password => 'toto13'
				}
			}.to_json

			post api('/users'), user_params, api_headers

			expect(response.status).to eq 409
		end
	end

	describe 'GET /users/:id' do
		it 'should respond json for user' do
			u = FactoryGirl.create :user

			get api("/users/#{u.id}"), {}, api_headers(token: u.token)

			expect(response.status).to eq 200
			expect(JSON.parse(response.body)['id']).to eq u.id
		end
	end

	describe 'GET /users/search' do
		it 'should find user' do
			u = FactoryGirl.create :user

			get api("/users/search"), {
				:query => u.username
			}, api_headers(token: u.token)

			expected_response = [u].to_json

			expect(response.status).to eq 200
			expect(response.body).to eq expected_response
		end
	end

	describe 'GET /users' do
		it 'should list public people' do
			u = FactoryGirl.create :public_user
			leo = FactoryGirl.create :user

			expected_response = [u].to_json

			get api("/users"), {}, api_headers(token: leo.token)

			expect(response.status).to eq 200
			expect(response.body).to eq expected_response
		end
	end

	describe 'PUT /users/:id' do
		it 'should update user' do
			u = FactoryGirl.create :user

			user_params = {
				:user => {
					:password => 'blabla'
				}
			}.to_json 

			put api("/users/#{u.id}"), user_params, api_headers(token: u.token)

			u.reload

			expect(response.status).to eq 200
			expect(u.password).to eq 'blabla'
		end

		it 'should update user audio' do
			u = FactoryGirl.create :user

			user_params = {
				:user => {
					:audio => {
						:file => 'bio.m4a'
					}
				}
			}.to_json 

			put api("/users/#{u.id}"), user_params, api_headers(token: u.token)

			u.reload

			expect(response.status).to eq 200
			expect(u.audio).to be_present
		end
	end

	describe 'DELETE /users/:id' do
		it 'should delete user' do
			u = FactoryGirl.create :user

			delete api("/users/#{u.id}"), {}, api_headers(token: u.token)

			expect(response.status).to eq 200
		end

		it 'should not delete another user' do
			leo = FactoryGirl.create :user
			glenn = FactoryGirl.create :another_user

			delete api("/users/#{leo.id}"), {}, api_headers(token: glenn.token)

			leo.reload

			expect(response.status).to eq 404
			expect(leo).to be_present
		end
	end
end