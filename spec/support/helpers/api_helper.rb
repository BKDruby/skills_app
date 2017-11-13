# frozen_string_literal: true

# Api helper
module ApiHelper
  def set_jwt_keys
    key = OpenSSL::PKey::RSA.new 1024
    Rails.application.config.jwt_private_key = key.to_pem
    Rails.application.config.jwt_public_key = key.public_key.to_pem
  end
end
