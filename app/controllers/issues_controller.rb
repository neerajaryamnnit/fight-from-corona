class IssuesController < ApplicationController
  before_action :authenticate_user!


  def list
    @issues = Issue.where(user_id: current_user.id)

  end

  def create

  end
end
