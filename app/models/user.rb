class User < ApplicationRecord

  has_secure_password
  has_secure_token :temp_token


  def generate_otp
    otp_expiration_mins = ENV['OTP_EXPIRATION_MINS'] ? ENV['OTP_EXPIRATION_MINS'].to_i : 5
    if otp_created_at.blank? || otp_created_at < (DateTime.now - otp_expiration_mins.minutes)
      otp = (SecureRandom.random_number(9e5) + 1e5).to_i.to_s
      self.otp = otp
      self.password = otp
      regenerate_temp_token
    end
    save
  end

  def valid_password?(password)

  end
end
