# frozen_string_literal: true

require "jwt"
require "openssl"

# Encode, decode JWT-token
class JsonWebToken
  extend ErrorHandler

  class << self
    def encode(payload = {}, token_expiration = nil)
      JWT.encode(payload.merge(expiration(token_expiration)), private_key, "RS256")
    end

    def decode(token)
      HashWithIndifferentAccess.new(JWT.decode(token, public_key, true, algorithm: "RS256")[0])
    rescue JWT::DecodeError
      log_warn("[JsonWebToken] Decoding error for token: #{token}")
      nil
    end

    private

    def expiration(time)
      return {} unless time
      {
        exp: Time.now.to_i + time.to_i
      }
    end

    def private_key
      OpenSSL::PKey::RSA.new(Rails.application.config.jwt_private_key.tr(",", "\n"))
    end

    def public_key
      OpenSSL::PKey::RSA.new(Rails.application.config.jwt_public_key.tr(",", "\n")).public_key
    end
  end
end
