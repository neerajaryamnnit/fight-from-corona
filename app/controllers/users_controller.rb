class UsersController < ApplicationController
  skip_forgery_protection
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
    @phone = user.mobile
    @token = user.temp_token
    @show_otp = true
    render 'home/index'
  end

  def login_params(params)
    params.require(:login).permit(:phone, :name, :otp)
  end

  def resend_otp

    unless params[:phone].present?
      render json: {title: "Missing Value!", error: "Phone number is missing number."}, status: 400
      return
    end
    if !params[:token].present? || !params[:token].strip.present?
      render json: { title:"Missing Value!" , error: "Token is missing." }, status: 400
      return
    end

    phone = params[:phone]
    token = params[:token].strip
    email = phone.to_s + "@fightfromcorona.com"
    user = User.where(email: email, temp_token: token).first

    unless user.present?
      render json: { title: "Not Found!" , message: "User not found for given value." }, status: 400
      return
    end

    unless user.otp_created_at < (DateTime.now.utc - 1.minutes)
      render json: { title: "Warning!" , message: "OTP can be resend after 1 minute." }, status: 400
      return
    end

    user.otp_created_at = DateTime.now
    user.save
    HTTParty.get("http://m1.sarv.com/api/v2.0/sms_campaign.php?token=#{ENV['SMS_PASSWORD']}&user_id=#{ENV['SMS_USER']}&route=TR&template_id=2096&sender_id=#{ENV['SMS_SENDER_ID']}&language=EN&template=Your+OTP+code+is+#{user.otp}&contact_numbers=#{phone}")
    render json: { title: "Congratulation!" , message: "Your otp has been resent." }, status: 200

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
