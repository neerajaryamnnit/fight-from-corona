class UsersController < ApplicationController
  skip_forgery_protection
  include UsersHelper
  def send_otp

    if request.method == "GET"
      redirect_to root_path
      return
    end

    if !params[:phone].present? || !params[:phone].strip.present?
      redirect_to root_path, flash: { error: "Please provide your phone number." }
      return
    end

    email = params[:phone].to_s + "@fightfromcorona.com"
    user = User.where(email: email).first
    if user.nil?
      user = User.create(email: email)
    end

    user.generate_otp
    user.reload
    send_otp_sms(user.mobile, user.otp)
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
    send_otp_sms(user.mobile, user.otp)
    render json: { title: "Congratulation!" , message: "Your otp has been resent." }, status: 200

  end

  def verify_otp

    if request.method == "GET"
      redirect_to root_path
      return
    end

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

  def change_locale
    unless params[:locale].present?
      redirect_to root_path
    end
    unless I18n.available_locales.include?(params[:locale].to_sym)
      redirect_to root_path
    end
    REDIS.set("LOCALE", params[:locale])
    session[:locale] = params[:locale]
    redirect_to root_path
  end

  def sign_up_data
    unless params[:name].present?
      flash[:error] = t(:name_validation)
      render 'users/sign_up'
      return
    end

    unless params[:phone].present?
      flash[:error] = t(:phone_validation)
      render 'users/sign_up'
      return
    end

    unless params[:pincode].present?
      flash[:error] = t(:pincode_validation)
      render 'users/sign_up'
      return
    end

    unless params[:thana].present?
      flash[:error] = t(:thana_validation)
      render 'users/sign_up'
      return
      end
    unless params[:district].present?
      flash[:error] = t(:distinct_validation)
      render 'users/sign_up'
      return
    end
    email = params[:phone].to_s + "@fightfromcorona.com"
    user = User.where(email: email).first
    unless user.present?
      user = User.new
    end
    user.name = params[:name]
    user.mobile = params[:phone]
    user.email = email
    user.thana = params[:thana]
    user.city = params[:district]
    user.pincode = params[:pincode]
    user.save

    user.generate_otp
    user.reload
    send_otp_sms(user.mobile, user.otp)
    @phone = params[:phone].to_s
    @token = user.temp_token
    @show_otp = true
    render 'home/index'
  end

  def sign_up

  end



end
