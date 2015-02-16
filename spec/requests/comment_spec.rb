require 'rails_helper'

describe 'Comments API' do

	before :each do
		@leo = FactoryGirl.create :user
		@glenn = FactoryGirl.create :another_user
		@story = FactoryGirl.create :story, user: @leo
		@page = FactoryGirl.create :page
		@story.pages << @page
		@story.receivers << @leo
	end

	describe 'POST /pages/:id/comments' do
		it 'should create comment on page' do
			post api("/pages/#{@page.id}/comments"), {
				:comment => {
					:audio => {
						:file => 'sample.m4a'
					}
				}
			}.to_json, api_headers(token: @leo.token)

			@page.reload

			expect(response.status).to eq 201
			expect(@page.comments.length).to eq 1
			expect(@page.comments.first.audio).to be_present
			expect(@page.comments.first.audio.file).to eq 'sample.m4a'
		end

		it 'should not create comment without access to page' do
			post api("/pages/#{@page.id}/comments"), {
				:comment => {
					:audio => {
						:file => 'sample.m4a'
					}
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

		it 'should not get the comment without access to story' do
			@comment = @page.comments.create!
			get api("/comments/#{@comment.id}"), {}, api_headers(token: @glenn.token)

			expect(response.status).to eq 404
		end
	end

	describe 'GET /pages/:id/comments' do
		it 'should list page comments' do
			@comment = @page.comments.create!(audio_id: 1)

			get api("/pages/#{@page.id}/comments"), {}, api_headers(token: @leo.token)

			expect(response.status).to eq 200
		end

		it 'should not list page comments if has no access to story' do
			@comment = @page.comments.create!(audio_id: 1)

			get api("/pages/#{@page.id}/comments"), {}, api_headers(token: @glenn.token)

			expect(response.status).to eq 404
		end
	end

	describe 'DELETE /comments/:id' do
		it 'should destroy comment if owner or story owner' do
			@story.receivers << @glenn
			comment = @page.comments.create(user: @glenn)

			delete api("/comments/#{comment.id}"), {}, api_headers(token: @glenn.token)

			@page.reload

			expect(response.status).to eq 200
			expect(@page.comments.length).to eq 0
		end

		it 'should not destroy if not owner or story owner' do
			comment = @page.comments.create(user: @leo)
			# @glenn has normally no access

			delete api("/comments/#{comment.id}"), {}, api_headers(token: @glenn.token)

			expect(response.status).to eq 404
			expect(@page.comments.length).to eq 1
		end
	end
end