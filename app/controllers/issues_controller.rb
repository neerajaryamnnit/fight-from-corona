class IssuesController < ApplicationController
  before_action :authenticate_user!


  def list
    @issues = Issue.where(user_id: current_user.id)

  end

  def create

  end

  def categories
    categories = IssueCategory.all.order(:asc)
    render status: 200, json: {message: "Category list", data: categories}
  end

  def sub_categories
    all = IssueSubCategory.all
    if params[:category_id].present?
      all.where(issue_category_id: params[:category_id]).order(:asc)
    end
    render status: 200, json: {message: "Sub Category  list", data: all}
  end
end
