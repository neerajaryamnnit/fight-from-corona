class IssuesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def list
    @issues = Issue.where(user_id: current_user.id, aasm_state: "open").order("created_at desc")
  end

  def create
    if request.method == "POST"
      unless params[:category].present?
        render json: {message: "Missing Value!", error: "Please provide your issue category"}, status: 422
        return
      end
      issue = Issue.new
      issue.issue_category_id = params[:category]
      issue.issue_sub_category_id = params[:sub_category] if params[:sub_category].present?
      issue.name = params[:name] if params[:name].present?
      issue.description = params[:description] if params[:description].present?
      issue.address = params[:address] if params[:address].present?
      issue.pincode = params[:pincode] if params[:pincode].present?
      issue.city = params[:city] if params[:city].present?
      issue.lat = params[:latitude] if params[:latitude].present?
      issue.long = params[:longitude] if params[:longitude].present?
      issue.user_id = current_user.id
      if issue.save
        render json: {message: "Issue saved successfully", data: issue}, status: 200
      else
        render json: {message: "Unable to save your issue this time.", error: "Error: " +issue.errors.full_messages.join(",")}, status: 400
      end
    end
  end

  def categories
    categories = IssueCategory.all.order(:name)
    render status: 200, json: { message: "Category list", data: categories }
  end

  def sub_categories
    all = IssueSubCategory.all
    if params[:category_id].present?
      all = all.where(issue_category_id: params[:category_id]).order(:name)
    end
    render status: 200, json: { message: "Sub Category  list", data: all }
  end
end
