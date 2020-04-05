class IssuesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def list
    @issues = Issue.where(user_id: current_user.id).order("created_at desc")

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
      issue.user_id = current_user.id
      issue.reported_at = DateTime.now
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

  # Parameters:
  # => latitude - String : Mandatory
  # => latitude - String: Mandatory
  # => radius - Integer: Optional - Default set to 10 Km
  # => all - Boolean: To show resloved issues too
  # Returns data: [{'issue': issue_1, 'distance': 2}, {'issue': issue_2, 'distance': 2}]
  def search_issues
    if params[:latitude].blank? || params[:longitude].blank?
      render json: { message: 'Missing Value!', error: 'Please enter your location' }, status: 422
    end
    if params[:radius].blank? || params[:radius] > 100
      # Default search radius 10 KM.
      params[:radius] = 10
    end
    sorted_issues = IssuesHelper.search_issues(params)
    render json: {
      message: "Nearby Issues",
      data: sorted_issues
    }, status: :ok
  end
end
