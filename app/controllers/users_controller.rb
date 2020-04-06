class UsersController < ApplicationController
  def send_otp

    if request.method == "GET"
      redirect_to root_path
      return
    end
    if !params[:name].present? || !params[:name].strip.present?
      redirect_to root_path, flash: { error: "Please provide your name." }
      return
    end
    if !params[:phone].present? || !params[:phone].strip.present?
      redirect_to root_path, flash: { error: "Please provide your phone number." }
      return
    end
    phone = params[:phone].strip
    name = params[:name].strip
    email = phone+ "@fightfromcorona.com"
    user = User.where(email: email).first
    if user.nil?
      user = User.create(email: email)
    end
    user.name = name
    user.mobile = phone
    user.generate_otp
    user.reload
    HTTParty.get("http://m1.sarv.com/api/v2.0/sms_campaign.php?token=#{ENV['SMS_PASSWORD']}&user_id=#{ENV['SMS_USER']}&route=TR&template_id=2096&sender_id=#{ENV['SMS_SENDER_ID']}&language=EN&template=Your+OTP+code+is+#{user.otp}&contact_numbers=#{phone}")
    puts user.otp
    @phone = user.mobile
    @token = user.temp_token
    @show_otp = true
    render 'home/index'
  end

  def login_params(params)
    params.require(:login).permit(:phone, :name, :otp)
  end

  def resend_otp

  end

  def verify_otp
    @phone = params[:phone].strip
    @token = params[:token].strip
    @show_otp = true
    if !params[:otp].present? || !params[:otp].strip.present?
      redirect_to root_path, flash: { error: "Please provide your OTP."}
      return
    end

    email = @phone + "@fightfromcorona.com"
    user = User.where(email: email, temp_token: @token).first

    if !user.authenticate(params[:otp])
      flash[:error] = "You have entered an incorrect OTP."
      render 'home/index'
    else
      session[:user_id] = user.id
      redirect_to root_path, flash: { error: "Login Successful"}
    end
  end
end
