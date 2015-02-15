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

			headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }

			post '/api/v1/users', user_params, headers

			expect(response.status).to eq 201
			expect(Api::User.first.username).to eq 'leoht'
		end
	end

	describe 'GET /users/:id' do
		it 'should respond json for user' do
			u = FactoryGirl.create :user, username: 'leoht', token: 'a23b687TYQfsdfsdf'

			get "/api/v1/users/#{u.id}", {}, {
				'Accept' => 'application/json',
				'X-Authorization-Token' => 'a23b687TYQfsdfsdf'
			}

			expect(response.status).to eq 200
			expect(Api::User.first.username).to eq 'leoht'
		end
	end
end