# frozen_string_literal: true

module Api
  module V1
    # API for authorization
    class AuthController < BaseController

      # POST /api/v1/sign_in
      def sign_in
        user = users_collection.authenticate(params[:email], params[:password])
        render_response("Invalid email or password", 401) && return unless user
        render json: {
          token: JsonWebToken.encode({ user_id: user.id }, jwt_lifetime)
        }, status: :ok
      rescue StandardError => e
        log_error(e, "[Api::V1::AuthorizationController] Authorization failed with params: #{params.inspect}")
        render_error(e)
      end

      private

      def jwt_lifetime
        Rails.application.config.jwt_default_lifetime unless params[:unlimited_expiry_time].eql?("true")
      end

      def users_collection
        User
      end
    end
  end
end
