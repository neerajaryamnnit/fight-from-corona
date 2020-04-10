module UsersHelper

  def send_otp_sms(mobile, otp = 123456)
    message = "Your+OTP+code+is+#{otp}"
    url = "http://m1.sarv.com/api/v2.0/sms_campaign.php?token=#{ENV['SMS_PASSWORD']}&user_id=#{ENV['SMS_USER']}&route=TR&template_id=2096&sender_id=#{ENV['SMS_SENDER_ID']}&language=EN&template=Your+OTP+code+is+#{otp}&contact_numbers=#{mobile}"
    res = HTTParty.get(url)
    SmsRequest.create!(request_url: url, response: res.body, response_code: res.code, phone: mobile, message: message )
  end
end
