require 'rails_helper'

describe 'API' do
	it 'should authenticate user' do
		u = FactoryGirl.create :user

		post api('/authenticate'), {
			:username => u.username,
			:password => 'toto13'
		}.to_json, api_headers

		expect(response.status).to eq 200
	end
end