class IssuesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def list
    @issues = Issue.where(user_id: current_user.id, aasm_state: ["open", "helping"]).order("created_at desc")
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

  def getIssues
    issues = Issue.all
    puts issues
    if params[:category].present?
      issues = issues.where(issue_category_id: params[:category])
    end
    if params[:sub_category].present?
      issues = issues.where(issue_sub_category_id: params[:sub_category])
    end
    if params[:date_range].present?
      date = params[:date_range]&.to_datetime
      issues = issues.where(['created_at >= ? AND created_at <= ?' ,(date+1).beginning_of_day ,(date+1).end_of_day ])
    end
    if params[:phone].present?
      issues = issues.joins(:user).merge(User.where(mobile: params[:phone]))
    end
    length = issues.count
    issues = issues.offset(params[:offset]).limit(params[:limit])
    if params[:csv].present?
      items = "name,number,address,pincode,category,subcategory,description,created_at\n"
      for issue in issues do
        items +=  issue.name.to_s+','+issue.user.mobile.to_s+','+issue.address.split(',')[0]+.to_s+','+issue.pincode.to_s+','+issue.issue_category.name.to_s+','+issue.issue_sub_category.name.to_s+','+issue.description.to_s+','+issue.created_at.to_s+"\n"
      end
      puts items
      render json: {title: "CSV Generated", message: "Download Available", data: items},status:200
      else
    render json: {title: "List Generated", message: "Filtered Issues", data: issues, length: length },state:200
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

  def want_to_help
    @issues = Issue.includes(:issue_category, :issue_sub_category, :user)
                  .where.not(user_id: current_user.id)
                  .where( aasm_state: ["open", "helping"]).order("created_at desc")
  end

  def call_pressed
    unless params[:issue_id].present?
      render json: {title: "Oops!", message: "Please provide the issue id which you want to call"}, status: 400
      return
    end

    issue_activity = IssueActivity.new
    issue_activity.name = "Call button clicked"
    issue_activity.issue_id = params[:issue_id]
    issue_activity.creator_id = current_user.id
    issue_activity.save!
    render json: {title: "Done", message: "Issue activity created"}, status: 200
  end

  def issue_help
    unless params[:issue_id].present?
      render json: {title: "Oops!", message: "Please provide the issue id which you want to call"}, status: 400
      return
    end
    unless Issue.find_by_id(params[:issue_id]).present?
      render json: {title: "Sorry!", message: "We are not able to find given issue id. Please check again"}, status: 400
      return
    end

    issue_activity = IssueActivity.new
    issue_activity.name = "Help clicked"
    issue_activity.issue_id = params[:issue_id]
    issue_activity.creator_id = current_user.id
    issue_activity.save!

    issue = Issue.find(params[:issue_id])
    if issue.may_mark_helping?
      issue.resolved_by_id = current_user.id
      issue.save!
      issue.mark_helping!
      render json: {title: "Thanks!", message: "We are happy that you are helping someone"}, status: 200
    else
      render json: {title: "Sorry!", message: "You can not help on this issue its already assigned"}, status: 400
    end
  end

  # Parameters:
  # => latitude - String : Mandatory
  # => latitude - String: Mandatory
  # => radius - Integer: Optional - Default set to 10 Km
  # => all - Boolean: To show resloved issues too
  # Returns data: [{'issue': issue_1, 'distance': 2}, {'issue': issue_2, 'distance': 2}]
  def search_issues
    if params[:latitude].blank? || params[:longitude].blank?
      render json: { title: 'Missing Value!', message: 'Please enter your location' } , status: 422
      return
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

  def want_to_help
    @issues = Issue.includes(:issue_category, :issue_sub_category, :user)
                  .where.not(user_id: current_user.id).where.not(issue_category_id: IssueCategory.suspected_patient)
                  .where( aasm_state: ["open", "helping"])
                  .order("created_at desc")
  end
end
