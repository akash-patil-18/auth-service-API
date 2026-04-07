class JsonWebToken
  # Use secret from ENV (never hardcode)
  SECRET_KEY = ENV['JWT_SECRET_KEY']

  # 🔐 Generate token
  def self.encode(payload, exp = 24.hours.from_now)
    # Add expiration time to payload
    payload[:exp] = exp.to_i

    # Encode payload into JWT token
    JWT.encode(payload, SECRET_KEY)
  end

  # 🔍 Decode token
  def self.decode(token)
    # Decode token using secret key
    decoded = JWT.decode(token, SECRET_KEY)[0]

    # Convert to hash with symbol keys
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::ExpiredSignature
    # Token expired
    nil
  rescue JWT::DecodeError
    # Invalid token
    nil
  end
end
