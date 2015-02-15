class Api::SubscriptionsController < ApiController
	before_filter :authenticate_request

	api!
	def create
		begin
			user = Api::User.find(params[:user_id])
			current_user.invite(user)

			render json: { message: 'Invited' }, status: :ok
		rescue ActiveRecord::RecordNotFound => e
			render nothing: true, status: :not_found
		end
	end

	api!
	def update
		begin
			subscription = Api::Subscribtion.find(params[:id])

			if current_user.id == subscription.subscriber_id
				subscription.update!(subscription_params)

				render json: subscription, status: :ok
			else
				render nothing: true, status: :not_found
			end

		rescue ActiveRecord::RecordNotFound => e
			render nothing: true, status: :not_found
		end
	end

	
	private
		def subscription_params
			params.require(:subscription).permit(:active)
		end

end