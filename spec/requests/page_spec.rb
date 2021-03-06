require 'rails_helper'

describe 'Page API' do

	before :each do |example|
		@glenn = FactoryGirl.create :user, username: "glenn"
		@story = FactoryGirl.create :story, user_id:@glenn.id, :title => 'Go to japan !'

	end

	describe 'POST /stories/:id/pages' do
		it 'should create a page associated to a story' do

			page_params = {
				:page => {
					:position => 1,
					:duration => 8
				}
			}.to_json

			post api("/stories/#{@story.id}/pages"), page_params, api_headers(token: @glenn.token)

			expect(response.status).to eq 201

			pj = JSON.parse(response.body)
			page = Api::Page.find pj['id']

			expect(page.story_id).to eq @story.id
			expect(@story.pages.include?(page)).to eq true
		end
	end

	describe 'POST /pages/:id/audio' do

		before :each do
			@page = @story.pages.create!(position: 1, duration: 8)
		end

		it 'should create page audio' do			
			bulk_sound = Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'bah.WAV'), 'audio/x-wav')

			file_params = {
					:file => bulk_sound
			}

			post api("/pages/#{@page.id}/audio"), file_params, api_headers(token: @glenn.token)

			expect(response.status).to eq 201
			expect(@page.audio).to be_present

			# expect(@page.audio.file).to eq Rails.root.join('spec', 'fixtures', 'output', 'bah.WAV').to_s

		end
	end

	describe 'POST /pages/:id/media' do
		before :each do
			@page = @story.pages.create!(position: 1, duration: 8)
		end

		it 'should create page media' do
			media = Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'steph.jpg'), 'image/jpeg')

			file_params = {
					:file => media
			}

			post api("/pages/#{@page.id}/media"), file_params, api_headers(token: @glenn.token)

			expect(response.status).to eq 201
			expect(@page.media).to be_present

			# expect(@page.media.file).to eq Rails.root.join('spec', 'fixtures', 'output', 'steph.jpg').to_s

		end
	end

	# describe 'PUT /pages/:id/audio' do
	# 	before :each do
	# 		@page = @story.pages.create!(position: 1, duration: 8)
	# 		path = Rails.root.join('spec', 'fixtures', 'files', 'bah.WAV').to_s
	# 		@page.create_audio!(file: path)
	# 	end

	# 	it 'should update page audio' do
	# 		put api("/pages/#{@page.id}/audio"), file_params, api_headers(token: @glenn.token)

	# 		expect(response.status).to eq 200
	# 	end
	# end

	# describe 'PUT /pages/:id/media' do
	# 	before :each do
	# 		@page = @story.pages.create!(position: 1, duration: 8)
	# 		path = Rails.root.join('spec', 'fixtures', 'files', 'steph.jpg').to_s
	# 		@page.create_audio!(file: path)
	# 	end

	# 	it 'should update page audio' do
	# 		put api("/pages/#{@page.id}/media"), file_params, api_headers(token: @glenn.token)

	# 		expect(response.status).to eq 200
	# 	end
	# end
end