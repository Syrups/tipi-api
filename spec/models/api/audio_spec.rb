require 'rails_helper'

describe Api::Audio do
	before :each do
		@leo = Api::User.create(username: 'leoht')
		@glenn = Api::User.create(username: 'glenn')

		@story = @leo.stories.create!(title: 'Bha bha !')

		@page1 = @story.pages.create!(position: 1, duration: 8)
		@page2 = @story.pages.create!(position: 2, duration: 10)
	end

	it 'should be in page1' do
	    

		bulk_sound = Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'bah.WAV'), 'audio/x-wav')

		name = bulk_sound.original_filename
	    directory = "#{::Rails.root}/spec/fixtures/output"
	    path = File.join(directory, name)

	    File.open(path, "wb") { |f| f.write(bulk_sound.read) }

		audio = @page1.create_audio!(file: "#{directory}/#{name}")
	

		expect(@page1.audio).to be_present
	end
end