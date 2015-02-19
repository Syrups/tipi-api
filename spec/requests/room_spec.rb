require 'rails_helper'

describe 'Rooms API' do

	describe 'POST /users/:id/rooms' do
		it 'should create a room'
		it 'should create room with users in it'
	end

	describe 'GET /users/:id/rooms' do
		it 'should list all rooms'
	end

	describe 'GET /rooms/:id/stories' do
		it 'should list all stories in room'
		it 'should filter stories with query tag'
	end

	describe 'POST /rooms/:id/users' do
		it 'should add user to room'
		it 'should not add if user is not friend'
	end

	describe 'GET /rooms/:id/users' do
		it 'shoud list users in room'
	end

	describe 'PUT /rooms/:id' do
		it 'should update room'
	end

	describe 'DELETE /rooms/:id/stories' do
		it 'should remove story from room'
	end

	describe 'DELETE /rooms/:id/users' do
		it 'should remove user from room'
	end

	describe 'DELETE /rooms/:id' do
		it 'should be destroyed by owner'
	end

end