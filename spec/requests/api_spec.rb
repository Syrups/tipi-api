require 'rails_helper'

describe 'API' do

	before :each do
		@user = FactoryGirl.create :user
	end

	it 'should authenticate user with right credentials' do
		post api('/authenticate'), {
			:username => @user.username,
			:password => 'toto13'
		}.to_json, api_headers

		expect(response.status).to eq 200
	end

	it 'should not authenticate user with wrong username' do
		post api('/authenticate'), {
			:username => 'idontexist',
			:password => 'thisisnotmypassword'
		}.to_json, api_headers

		expect(response.status).to eq 404
	end

	it 'should not authenticate user with wrong password' do
		post api('/authenticate'), {
			:username => @user.username,
			:password => 'thisisnotmypassword'
		}.to_json, api_headers

		expect(response.status).to eq 404
	end

	it 'should not authorize unauthenticated user' do
		get api("/users/#{@user.id}"), {}, api_headers

		expect(response.status).to eq 401
	end

	it 'should not found' do
		get api("/foo"), {}, api_headers

		expect(response.status).to eq 404
	end
end