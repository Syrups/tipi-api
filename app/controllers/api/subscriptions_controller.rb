class Api::SubscriptionsController < ApiController
	before_filter :authenticate_request

	def create

		user = Api::User.find(params[:user_id])

		if user.present?
			current_user.invite(user)

			render json: { message: 'Invited' }, status: :ok
		else
			render nothing: true, status: :not_found
		end
	end

	def update
		subscription = Api::Subscribtion.find(params[:id])

		if subscription.present?
			subscription.update!(subscription_params)

			render json: { message: "Subscribed" }, status: :ok
		else
			render nothing: true, status: :not_found
		end
	end

	private
		def subscription_params
			params.require(:subscription).permit(:active)
		end

end