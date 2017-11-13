# frozen_string_literal: true

module Api
  # Base API controller
  class BaseController < ActionController::Base
    include Swagger::Blocks
    include ApiHelper
    include ErrorHandler

    swagger_schema :ApiError do
      key :required, %i[message status]
      property :message do
        key :type, :string
      end
      property :status do
        key :type, :integer
        key :format, :int32
      end
    end

    # protect_from_forgery with: :null_session
  end
end
