require 'rails_helper'

describe 'Page API' do

	before :each do |example|
		@glenn = FactoryGirl.create :user, username: "glenn"
		@story = FactoryGirl.create :story, user_id:@glenn.id, :title => 'Go to japan !'

	end

	describe 'POST /users/:id/stories/:id/pages' do
		it 'should create a page associated to a story' do

			page_params = {
				:story => {
				}
			}.to_json

			post api("/stories/#{@story.id}/pages"), page_params, api_headers(token: @glenn.token)

			expect(response.status).to eq 201

			pj = JSON.parse(response.body)
			page = Api::Page.find pj['id']

			expect(page.story_id).to eq @story.id
		end

		it 'should create a page associated to a story with audio' do			
			
			post api("/stories/#{@story.id}/pages"), {}, api_headers(token: @glenn.token)

			expect(response.status).to eq 201

			page = Api::Page.find JSON.parse(response.body)['id']
			expect(page.story_id).to eq @story.id

			bulk_sound = Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'bah.WAV'), 'audio/x-wav')
			
			puts page.inspect

			file_params = {
				:audio => {
					:file => bulk_sound
				}
			}

			post api("/pages/#{page.id}/audio"), file_params, api_headers(token: @glenn.token)
		end
	end
end