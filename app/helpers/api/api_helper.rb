# frozen_string_literal: true

module Api
  # Api helpers
  module ApiHelper
    def render_not_authorized
      render_response("Not authorized", 401)
    end

    def render_error(e)
      render_response(e.message, 500)
    end

    def render_response(message, status)
      render json: {
        message: message,
        status: status
      }, status: status
    end
  end
end
