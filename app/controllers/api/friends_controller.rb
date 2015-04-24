class Api::FriendsController < ApiController
	before_filter :authenticate_request

	api!
	def create
		begin
			friend = Api::User.find(params[:friend_id])
			current_user.add_friend friend

			render json: friend.to_json(:exclude => [:token, :salt, :password]), status: :created
		rescue ActiveRecord::RecordNotFound
			render nothing: true, status: :not_found
		end
	end

	def index
		render json: current_user.friends
	end

	def pending
		render json: current_user.requesting
	end

	def accept
		begin
			friend = Api::User.find(params[:friend_id])
			current_user.accept_friend friend

			render nothing: true, status: :ok
		rescue ActiveRecord::RecordNotFound
			render nothing: true, status: :not_found
		end
	end

	api!
	def destroy
		begin
			friend = Api::User.find(params[:friend_id])
			current_user.unfriend friend

			render nothing: true
		rescue ActiveRecord::RecordNotFound
			render nothing: true, status: :not_found
		end
	end
end
