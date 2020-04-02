class HomeController < ApplicationController

  before_action :authenticate_user!, except: [:index]
  def index

    @show_otp = false
  end

end
