class RatingsController < ApplicationController
  unloadable

  #Authorize against global permissions defined in init.rb
  # ?? does prevent everythin below admin?
  # TODO - find out how this works
  #before_filter :authorize_global
  #before_filter :authorize

  # Callback function called by the jquery.raty.js instance on page.
  def update_rating
    # Check if user can rate issue in current project.
    @issue = Issue.find(params[:id])
    @project = Project.find(@issue.project_id)
    if User.current.allowed_to?(:rate_issue, @project)
        # Update issue rating and timestamp attributes.
        begin
          # Find existing rating for issue from current user.
          @rating = IssueRating.find_by!("issue_id = ? AND user_id = ?", @issue.id, User.current.id)
          # if a rating is found, update its value.
          @rating.rating_val = params[:rating]
        rescue ActiveRecord::RecordNotFound
          # if no rating is found, create a new one with submitted value.
          @rating = IssueRating.new(
            issue_id: @issue.id,
            user_id: User.current.id,
            rating_val: params[:rating]
          )
        end
        # Save the issue rating item.
        @rating.save
        # return HTML and JS.
        respond_to do |format|
          format.html {redirect_to @issue}
          format.js
        end
    end
  end
end
