require 'rails_helper'

describe 'Comments API' do

	before :each do
		@leo = FactoryGirl.create :user
		@glenn = FactoryGirl.create :another_user
		@story = FactoryGirl.create :story
		@page = FactoryGirl.create :page
		@story.pages << @page
		@story.receivers << @leo
	end

	describe 'POST /pages/:id/comments' do
		it 'should create comment on page' do
			post api("/pages/#{@page.id}/comments"), {
				:comment => {
					:audio_id => 1
				}
			}.to_json, api_headers(token: @leo.token)

			expect(response.status).to eq 201
		end

		it 'should not create comment without access to page' do
			post api("/pages/#{@page.id}/comments"), {
				:comment => {
					:audio_id => 1
				}
			}.to_json, api_headers(token: @glenn.token)

			expect(response.status).to eq 404
		end
	end

	describe 'GET /comments/:id' do
		it 'should get the comment'
	end

	describe 'GET /pages/:id/comments' do
		it 'should list page comments'
	end

	describe 'DELETE /comments/:id' do
		it 'should destroy comment'
	end
end