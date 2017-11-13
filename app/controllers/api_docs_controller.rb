# frozen_string_literal: true

# To integrate these definitions with Swagger UI, we need a docs controller that can serve the JSON definitions.
class ApiDocsController < ActionController::Base
  include Swagger::Blocks

  swagger_root do
    key :swagger, "2.0"
    info do
      key :version, "1.0.0"
      key :title, "Skills API"
      # key :description, 'A sample API that uses a petstore as an example to ' \
      #                   'demonstrate features in the swagger-2.0 specification'
      # key :termsOfService, 'http://helloreverb.com/terms/'
      contact do
        key :name, "BKDev Ruby"
      end
      # license do
      #   key :name, 'MIT'
      # end
    end
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
    Api::BaseController,
    Api::V1::UsersController::Docs,
    Api::V1::AuthController::Docs,
    self
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
