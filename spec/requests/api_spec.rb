require 'rails_helper'

describe 'API' do
	it 'should authenticate user' do
		u = FactoryGirl.create :user

		post api('/authenticate'), {
			:username => u.username,
			:password => u.password
		}.to_json, api_headers

		expect(response.status).to eq 200
		response.body.should = {
			:id => u.id,
			:token => u.token
		}.to_json
	end
end