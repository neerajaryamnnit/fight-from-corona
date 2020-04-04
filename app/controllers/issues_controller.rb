class IssuesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def list
    @issues = Issue.where(user_id: current_user.id, aasm_state: "open").order("created_at desc")
  end

  def create
    if request.method == "POST"
      unless params[:category].present?
        render json: { title: "Missing Value!", message: "Please provide your issue category"}, status: 422
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
        render json: {title: "Congratulation!",  message: "Issue saved successfully", data: issue}, status: 200
      else
        render json: {title: "Oops!", message: "Unable to save your issue this time.", error: "Error: " +issue.errors.full_messages.join(",")}, status: 400
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
    render status: 200, json: {title: "Success",  message: "Sub Category  list", data: all }
  end
  def resolve
    unless params[:id].present?
      render json: {title: "Oops!", message: "Please provide the issue id which you want to resolve"}, status: 400
      return
    end

    unless Issue.find_by_id(params[:id]).present?
      render json: {title: "Oops!", message: "We are not able to find the given issue id"}, status: 400
      return
    end
    issue = Issue.find(params[:id])

    if issue.may_mark_resolve?
      issue.mark_resolve!
      render json: {title: "Congratulations!", message: "We are happy to resolve your issue." , data: issue}, status: 200
    else
      render json: {title: "Oops!", message: "It seems your issue is already resolved"}, status: 400
    end
  end
end
