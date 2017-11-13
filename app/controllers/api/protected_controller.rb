# frozen_string_literal: true

module Api
  # This API controller will check token header to be valid
  class ProtectedController < BaseController
    attr_reader :current_user
    before_action :authenticate

    protected

    def authenticate
      token = request.headers["access-token"]
      decoded_token = JsonWebToken.decode(token) if token
      render_response("Invalid token", 401) && return unless decoded_token
      set_session(decoded_token)
      render_response("Can't find user token was issued for", 403) unless current_user
    end

    private

    def set_session(decoded_token)
      @current_user = users_collection.find_by(id: decoded_token[:user_id])
    end

    def admin?
      current_user.admin?
    end

    def not_admin?
      !admin?
    end

    def users_collection
      User
    end
  end
end
