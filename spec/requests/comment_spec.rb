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
			expect(@page.comments.length).to eq 1
		end

		it 'should not create comment without access to page' do
			post api("/pages/#{@page.id}/comments"), {
				:comment => {
					:audio_id => 1
				}
			}.to_json, api_headers(token: @glenn.token)

			expect(response.status).to eq 404
			expect(@page.comments.length).to eq 0
		end
	end

	describe 'GET /comments/:id' do
		it 'should get the comment' do
			@comment = @page.comments.create!
			get api("/comments/#{@comment.id}"), {}, api_headers(token: @leo.token)

			expect(response.status).to eq 200
		end

		# it 'should not get the comment without access to story' do
		# 	@comment = @page.comments.create!
		# 	puts @comment.id
		# 	get api("/comments/#{@comment.id}"), {}, api_headers(token: @glenn.token)

		# 	expect(response.status).to eq 404
		# end
	end

	describe 'GET /pages/:id/comments' do
		it 'should list page comments' do
			@comment = @page.comments.create!(audio_id: 1)

			get api("/pages/#{@page.id}/comments"), {}, api_headers(token: @leo.token)

			expect(response.status).to eq 200
		end
	end

	describe 'DELETE /comments/:id' do
		it 'should destroy comment if owner or story owner' do
			@story.receivers << @glenn
			@comment = @page.comments.create(user: @glenn)

			delete api("/comments/#{@comment.id}"), {}, api_headers(token: @glenn.token)

			@page.reload

			expect(response.status).to eq 200
			expect(@page.comments.length).to eq 0
		end
	end
end