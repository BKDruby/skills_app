# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::UsersController, type: :controller do
  let!(:user) { create :user, role: :admin }
  let(:admin_user) { create :user, role: :admin }
  let(:client_user) { create :user, role: :client }
  let(:users_collection) { User }
  let(:user_params) do
    {
      email: Faker::Internet.email,
      password: Faker::Internet.password,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      phone: Faker::PhoneNumber.cell_phone
    }
  end

  before do
    set_jwt_keys
    token = JsonWebToken.encode(user_id: user.id)
    request.headers["access-token"] = token
  end

  describe "GET #index" do
    before do
      10.times { create :user }
    end

    it "should return 401 if there is no token" do
      request.headers["access-token"] = ""
      get :index
      expect(response).to have_http_status(:unauthorized)
    end

    it "should return a list of users" do
      get :index
      expect(response).to have_http_status(:success)
      users = JSON.parse(response.body)
      expect(users.count).to eql users_collection.count
      user = users.last
      expect(user).to have_key "email"
      expect(user).to have_key "id"
    end

    context "if the user is a client" do
      before do
        user.update role: :client
      end

      it "should return a list of users who are clients" do
        get :index
        expect(response).to have_http_status(:success)
        users = JSON.parse(response.body)
        expect(users.count).to eql users_collection.client.count
        user = users.last
        expect(user).to have_key "email"
        expect(user).to have_key "id"
        expect(user).to have_key "role"
      end
    end

    context "if the sort parameter is present" do
      let(:user1) { create :user, email: "1test@test.com" }
      let(:user2) { create :user, email: "2test@test.com" }
      let(:user3) { create :user, email: "3test@test.com" }

      before do
        (User.all.to_a - [user]).each(&:delete)
        user.update email: "2@test.com", profile_attributes: { first_name: "2" }
        user1.profile.update first_name: "2"
        user2.profile.update first_name: "3"
        user3.profile.update first_name: "1"
      end

      it "should return a sorted list of users" do
        get :index, sort: "email"
        users = JSON.parse(response.body)
        expect(users.first["email"]).to eql user1.email
        get :index, sort: "-first_name"
        users = JSON.parse(response.body)
        expect(users.first["email"]).to eql user2.email
      end
    end
  end

  describe "GET #show" do
    it "should return user details" do
      get :show, id: admin_user.id
      expect(response).to have_http_status(:success)
      user = JSON.parse(response.body)
      expect(user).to have_key "email"
      expect(user).to have_key "id"
      expect(user).to have_key "first_name"
      expect(user).to have_key "last_name"
      expect(user).to have_key "phone"
      expect(user).to have_key "role"
    end

    it "should return an error 404 if the user is not found" do
      get :show, id: 0
      expect(response).to have_http_status(:not_found)
    end

    context "if the user is a client" do
      before do
        user.update role: :client
      end

      it "should return the details of the actual profile" do
        get :show, id: user.id, format: :json
        expect(response).to have_http_status(:success)
        user = JSON.parse(response.body)
        expect(user).to have_key "email"
        expect(user).to have_key "id"
        expect(user).to have_key "first_name"
        expect(user).to have_key "last_name"
        expect(user).to have_key "phone"
      end

      it "should return an access error for administrator accounts" do
        get :show, id: admin_user.id
        expect(response).to have_http_status(:forbidden)
        expect(JSON.parse(response.body)["message"]).to include "not allowed"
      end
    end

    context "if the email is set as a search parameter" do
      it "should search by email" do
        get :show, field: :email, value: user.email
        expect(response).to have_http_status(:success)
        response_user = JSON.parse(response.body)
        expect(user.email).to eql response_user["email"]
      end
    end

    context "if the email is set as a search parameter" do
      it "should search by email" do
        get :show, field: :email, value: user.email
        expect(response).to have_http_status(:success)
        response_user = JSON.parse(response.body)
        expect(user.email).to eql response_user["email"]
      end
    end

    context "if the first_name is set as a search parameter" do
      it "should search by first_name" do
        get :show, field: :first_name, value: user.profile.first_name
        expect(response).to have_http_status(:success)
        response_user = JSON.parse(response.body)
        expect(user.profile.first_name).to eql response_user["first_name"]
      end
    end

    context "if the last_name is set as a search parameter" do
      it "should search by last_name" do
        get :show, field: :last_name, value: user.profile.last_name
        expect(response).to have_http_status(:success)
        response_user = JSON.parse(response.body)
        expect(user.profile.last_name).to eql response_user["last_name"]
      end
    end

    context "if an invalid search term is set" do
      it "should return bad request" do
        get :show, field: :role, value: "user"
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)["message"]).to include "Invalid field"
      end
    end
  end

  describe "POST #create" do
    it "should return errors if the record is not valid" do
      post :create, email: 22
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)["message"])
        .to include "Email is invalid; Email is invalid; Password can't be blank; Password can't be blank"
    end

    it "should create a user with a profile" do
      expect { post :create, user_params }.to change { users_collection.count }
      user = users_collection.last
      expect(user.email).to eql user_params[:email]
      expect(user.profile.attributes.symbolize_keys).to include user_params.slice(:first_name, :last_name, :phone)
    end
  end

  context "if the user is a client" do
    before do
      user.update role: :client
    end

    it "should return an access error for creating" do
      expect { post :create, user_params }.to_not change { users_collection.count }
      expect(response).to have_http_status(:forbidden)
      expect(JSON.parse(response.body)["message"]).to include "not allowed"
    end
  end

  describe "PUT #update" do
    it "should update the user" do
      expect { put :update, user_params.merge(id: admin_user.id) }.to change { admin_user.reload.email }
        .and change { admin_user.profile.reload.first_name }
        .and change { admin_user.profile.reload.last_name }
        .and change { admin_user.profile.reload.phone }
      expect(response).to have_http_status(:no_content)
    end

    it "should return an error 404 if the user is not found" do
      put :update, user_params.merge(id: 0)
      expect(response).to have_http_status(:not_found)
    end

    context "if the user is a client" do
      before do
        user.update role: :client
      end

      it "should return an access error for updating" do
        expect { put(:update, user_params.merge(id: client_user.id)) }
          .to_not change { client_user.reload.email }
        expect(response).to have_http_status(:forbidden)
        expect(JSON.parse(response.body)["message"]).to include "not allowed"
      end

      it "should update its own data except role" do
        expect { put :update, user_params.merge(id: user.id, role: "admin") }.to change { user.reload.email }
          .and change { user.profile.reload.first_name }
          .and change { user.profile.reload.last_name }
          .and change { user.profile.reload.phone }
        expect(user.reload.role).to eql "client"
        expect(response).to have_http_status(:no_content)
      end
    end
  end

  describe "DELETE #destroy" do
    it "should delete the user" do
      expect { delete(:destroy, id: client_user.id) }
        .to change { users_collection.exists?(id: client_user.id) }
      expect(response).to have_http_status(:no_content)
    end

    it "should return an error 404 if the user is not found" do
      delete :destroy, user_params.merge(id: 0)
      expect(response).to have_http_status(:not_found)
    end

    context "if the user is a client" do
      before do
        user.update role: :client
      end

      it "should return an access error for deleting" do
        expect { delete(:destroy, user_params.merge(id: client_user.id)) }
          .to_not change { client_user.reload.email }
        expect(response).to have_http_status(:forbidden)
        expect(JSON.parse(response.body)["message"]).to include "not allowed"
      end
    end
  end
end
