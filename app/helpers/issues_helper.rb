require 'utils/utility.rb'

module IssuesHelper

  # Helper Function to filter issues.
  # Currently only on state and radius
  def self.search_issues(params)
    search_hash = {}
    if params[:all].blank?
      search_hash[:aasm_state] = :open
    end

    filtered_issues = []
    user_geo_loc = [params[:latitude].to_f, params[:longitude].to_f]
    issues = Issue.where(search_hash) # .includes(:issue_category) - To filter out report a patient
    issues.each do |issue|
      issue_geo_loc = [issue.lat, issue.long]
      distance = Utility.haversine_distance(user_geo_loc, issue_geo_loc)
      if distance <= params[:radius]
        filtered_issues << { 'issue' => issue, 'distance' => distance }
      end
    end

    # Return Issues sorted by distance
    filtered_issues.sort_by { |hash| hash['distance'] }
  end
end
