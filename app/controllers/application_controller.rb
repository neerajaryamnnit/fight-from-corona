# frozen_string_literal: true
class ApplicationController < ActionController::Base
  include ApplicationHelper
  helper_method :current_user
  helper_method :daily_case
  helper_method :user_signed_in?
  helper_method :authenticate_user!
  around_action :switch_locale

  def current_user
    # Look up the current user based on user_id in the session cookie:
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def daily_case
    @daily_case ||= DailyCase.last
  end
  def user_signed_in?
    current_user != nil
  end

  def authenticate_user!
    if current_user.nil?
      session.delete(:user_id)
      redirect_to root_path, flash: {error: 'Your must be logged in to access this page'}
    end
  end

  def switch_locale(&action)
    locale = if session[:locale].present?
      session[:locale]
    else
      session[:locale] = I18n.default_locale 
             end
    I18n.with_locale(locale, &action)
  end
end
