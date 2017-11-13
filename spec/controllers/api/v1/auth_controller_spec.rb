# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::AuthController, type: :controller do
  let(:auth_params) do
    {
      email: "test@email.com",
      password: "12345678"
    }
  end
  let!(:user) { create :user, auth_params }

  describe "POST #sign_in" do
    it "should return a token for authorization" do
      post :sign_in, auth_params
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to have_key "token"
    end
  end
end
