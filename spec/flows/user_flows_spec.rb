require 'rails_helper'

RSpec.describe "UserFlows", type: :request do
	describe 'User signup and login' do
	  it "should create an account then login" do
			user_params = {
				:user => {
					:username => 'leoht',
					:password => 'toto13'
				}
			}.to_json

			post api('/users'), user_params, api_headers

			expect(response.status).to eq 201

			jres = JSON.parse(response.body)

			id = jres['id']
			token = jres['token']

			post api('/authenticate'), {
				:username => 'leoht',
				:password => 'toto13'
			}.to_json, api_headers

			expect(response.status).to eq 200

			jres = JSON.parse(response.body)

			expect(jres['token']).to be_present
			expect(jres['token']).to eq token
	  end
	end

	describe 'Story creation' do
		before :each do
			@leo = FactoryGirl.create :user
		end

		it 'should create a story and upload medias' do
			story_params = {
				:story => {
					:title => 'Nice story',
					:page_count => 10,
					:type => 'private',
				}
			}.to_json

			post api("/users/#{@leo.id}/stories"), story_params, api_headers(token: @leo.token)

			expect(response.status).to eq 201
			expect(@leo.stories.first.title).to eq 'Nice story'

			@story = @leo.stories.first

			expect(@story.pages.length).to eq 10

			media = Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'steph.jpg'), 'image/jpeg')

			file_params = {
				:media => {
					:file => media
				}
			}

			@page = @story.pages.first

			post api("/pages/#{@page.id}/media"), file_params, api_headers(token: @leo.token)

			expect(response.status).to eq 201
			expect(@page.media).to be_present
		end
	end
end
