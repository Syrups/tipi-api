require 'rails_helper'

RSpec.describe Api::Comment, type: :model do

	before :each do
		@leo = FactoryGirl.create :user
		@glenn = FactoryGirl.create :another_user
		@story = @leo.stories.create!(title: 'My story')
		@story.receivers << @glenn
		@page = @story.pages.create!
		@comment = @page.comments.create!(user: @glenn)
	end

  it 'should be readable' do
  	expect(@comment.can_read?(@leo)).to eq true
  	expect(@comment.can_read?(@glenn)).to eq true
  end

  it 'should be touchable' do
  	expect(@comment.can_touch?(@glenn)).to eq true
  	expect(@comment.can_touch?(@leo)).to eq true
  end

  it 'should not be readable' do
  	olly = FactoryGirl.create :user, username: 'olly'

  	expect(@comment.can_read?(olly)).to eq false
  end

  it 'should not be touchable' do
  	thib = FactoryGirl.create :user, username: 'thib'
  	@story.receivers << thib

  	expect(@comment.can_touch?(thib)).to eq false
  end
end
