class UsersController < ApplicationController
  def send_otp

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
      user = User.create(email: email, password: "sdkjfsn9320923inde0293029")
    end
    user.name = name
    user.mobile = phone
    otp = user.generate_otp
    puts user.otp
    @phone = user.mobile
    @token = user.temp_token
    @show_otp = true
    render 'home/index'
  end

  def login_params(params)
    params.require(:login).permit(:phone, :name, :otp)
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
