require 'rails_helper'

describe 'Subscribtion API' do
	describe 'POST /users/:id/subscriptions' do
		it 'should send an subscription invitation to glenn' do
			leo = FactoryGirl.create :user
			glenn = FactoryGirl.create :another_user

			post api("/users/#{glenn.id}/subscriptions"), {
				:subscription => { :enabled => false }
			}.to_json, api_headers(token: leo.token)

			glenn.reload!

			expect(glenn.invitations.count).to eq 1
		end
	end

	describe 'POST /users/:id/subscribers' do
		it 'should subscribe to this user'
	end

	describe 'PUT /subscriptions/:id' do
		it 'should disable subscription'
	end
end