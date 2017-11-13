# frozen_string_literal: true

# swagger documentation
module Api::V1::AuthController::Docs
  include Swagger::Blocks

  # rubocop:disable BlockLength
  swagger_path "/api/v1/auth/sign_in" do
    operation :post do
      key :summary, "Sign in with email and password"
      key :description, "Signs user in using email and password. "\
                              "Returns authorization token (JWT token) which will expire in 1 month."
      key :consumes, ["application/json"]
      key :produces, ["application/json"]
      key :tags, ["users"]
      parameter do
        key :name, :body_params
        key :description, "User credentials"
        key :in, :body
        key :required, true
        schema do
          key :"$ref", :TokenParams
        end
      end
      response 200 do
        key :description, "User authenticated successfully. Token returned in response."
        schema do
          key :"$ref", :Token
        end
      end
      response 401 do
        key :description, "Invalid email or password"
        schema do
          key :"$ref", :ApiError
        end
      end
      response 500 do
        key :description, "Unexpected error"
        schema do
          key :"$ref", :ApiError
        end
      end
    end
  end

  swagger_schema :Token do
    key :required, [:token]
    property :token do
      key :description, "JWT token"
      key :type, :string
    end
  end

  swagger_schema :TokenParams do
    property :email do
      key :description, "User email"
      key :type, :string
    end
    property :password do
      key :description, "User password"
      key :type, :string
    end
    property :unlimited_expiry_time do
      key :description, "true if you need token without expiration"
      key :type, :boolean
    end
  end
end
