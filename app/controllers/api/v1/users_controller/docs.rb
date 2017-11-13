# frozen_string_literal: true

# swagger documentation
module Api::V1::UsersController::Docs # rubocop:disable ModuleLength
  include Swagger::Blocks

  # rubocop:disable BlockLength
  swagger_path "/api/v1/users" do
    operation :get do
      key :summary, "Get list of users"
      key :description, "Get list of all users (for admin) or clients users (for client)"
      key :consumes, ["application/json"]
      key :produces, ["application/json"]
      key :tags, [:users]
      parameter do
        key :name, "access-token"
        key :description, "Authorization token"
        key :in, :header
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, "sort"
        key :description, "Sorting by fields. for example `-email,first_name`"
        key :in, :query
        key :required, false
        key :type, :string
      end
      response 200 do
        key :description, "Users list"
        schema type: :array do
          key :"$ref", :CutUser
        end
      end
      response 500 do
        key :description, "Unexpected error"
        schema do
          key :"$ref", :ApiError
        end
      end
    end
    operation :post do
      key :summary, "Create user"
      key :description, "Register new user"
      key :consumes, ["application/json"]
      key :produces, ["application/json"]
      key :tags, [:users]
      parameter do
        key :name, "access-token"
        key :description, "Authorization token"
        key :in, :header
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :body_params
        key :description, "User params"
        key :in, :body
        key :required, true
        schema do
          key :"$ref", :UserParams
        end
      end
      response 200 do
        key :description, "User created"
        schema do
          key :"$ref", :UserCreated
        end
      end
      response 400 do
        key :description, "Invalid params"
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

  swagger_path "/api/v1/users/{id}" do
    operation :get do
      key :summary, "Returns user information"
      key :description, "Get user profile"
      key :consumes, ["application/json"]
      key :produces, ["application/json"]
      key :tags, [:users]
      parameter do
        key :name, "access-token"
        key :description, "Authorization token"
        key :in, :header
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, "id"
        key :description, "user id"
        key :in, :path
        key :required, true
        key :type, :string
      end
      response 200 do
        key :description, "Users returned"
        schema do
          key :"$ref", :User
        end
      end
      response 401 do
        key :description, "Token is not valid"
        schema do
          key :"$ref", :ApiError
        end
      end
      response 403 do
        key :description, "Token issued for an unknown entity"
        schema do
          key :"$ref", :ApiError
        end
      end
    end
    operation :delete do
      key :summary, "Deletes user"
      key :description, "Deletes user"
      key :tags, [:users]
      parameter do
        key :name, "access-token"
        key :description, "Authorization token"
        key :in, :header
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, "id"
        key :description, "user id"
        key :in, :path
        key :required, true
        key :type, :string
      end
      response 204 do
        key :description, "User deleted"
      end
      response 401 do
        key :description, "Token is not valid"
        schema do
          key :"$ref", :ApiError
        end
      end
      response 403 do
        key :description, "Token issued for an unknown entity"
        schema do
          key :"$ref", :ApiError
        end
      end
    end
    operation :put do
      key :summary, "Updates user info"
      key :description, "Updates user info"
      key :consumes, ["application/json"]
      key :tags, [:users]
      parameter do
        key :name, "access-token"
        key :description, "Authorization token"
        key :in, :header
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, "id"
        key :description, "user id"
        key :in, :path
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :email
        key :description, "user email"
        key :in, :query
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :password
        key :description, "password"
        key :type, :string
        key :in, :query
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :first_name
        key :description, "first name"
        key :type, :string
        key :in, :query
        key :required, false
      end
      parameter do
        key :name, :last_name
        key :description, "last name"
        key :type, :string
        key :in, :query
        key :required, false
      end
      parameter do
        key :name, :role
        key :description, "role (admin or client)"
        key :type, :string
        key :in, :query
        key :required, false
      end
      parameter do
        key :name, :phone
        key :description, "phone number"
        key :type, :string
        key :in, :query
        key :required, false
      end
      response 204 do
        key :description, "User updated."
      end
      response 400 do
        key :description, "User is not updated"
        schema do
          key :"$ref", :ApiError
        end
      end
      response 401 do
        key :description, "Token is not valid"
        schema do
          key :"$ref", :ApiError
        end
      end
      response 403 do
        key :description, "Token issued for an unknown entity"
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

  swagger_schema :User do
    property :id do
      key :description, "id of user"
      key :type, :integer
      key :format, :int32
    end
    property :email do
      key :description, "email"
      key :type, :string
    end
    property :first_name do
      key :description, "first name"
      key :type, :string
    end
    property :last_name do
      key :description, "last name"
      key :type, :string
    end
    property :role do
      key :description, "role"
      key :type, :string
    end
    property :phone do
      key :description, "phone number"
      key :type, :string
    end
  end

  swagger_schema :CutUser do
    property :id do
      key :description, "id of user"
      key :type, :integer
      key :format, :int32
    end
    property :email do
      key :description, "email"
      key :type, :string
    end
    property :role do
      key :description, "role"
      key :type, :string
    end
  end

  swagger_schema :UserCreated do
    property :message do
      key :description, "Message with created user id"
      key :type, :string
    end
  end

  swagger_schema :UserParams do
    key :required, %i[email password]
    property :email do
      key :description, "user email"
      key :type, :string
    end
    property :password do
      key :description, "password"
      key :type, :string
    end
    property :first_name do
      key :description, "first name"
      key :type, :string
    end
    property :last_name do
      key :description, "last name"
      key :type, :string
    end
    property :role do
      key :description, "role (admin or client)"
      key :type, :string
    end
    property :phone do
      key :description, "phone number"
      key :type, :string
    end
  end
end
