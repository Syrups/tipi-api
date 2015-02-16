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
			expect(Api::User.first.username).to eq 'leoht'
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

	describe 'PUT /users/:id' do
		it 'should update user' do
			u = FactoryGirl.create :user

			user_params = {
				:user => {
					:password => 'blabla'
				}
			}.to_json 

			put api("/users/#{u.id}"), user_params, api_headers(token: u.token)

			expect(response.status).to eq 200
			expect(Api::User.first.password).to eq 'blabla'
		end
	end

	describe 'DELETE /users/:id' do
		it 'should delete user' do
			u = FactoryGirl.create :user

			delete api("/users/#{u.id}"), {}, api_headers(token: u.token)

			expect(response.status).to eq 200
		end
	end
end