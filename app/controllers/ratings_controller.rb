class RatingsController < ApplicationController
  unloadable

  # Callback function called by the jquery.raty.js instance on page.
  def update_rating
    # Check if user can rate issue in current project.
    @issue = Issue.find(params[:id])
    @project = Project.find(@issue.project_id)
    if User.current.allowed_to?(:rate_issue, @project)
        if @issue.update_attributes(rating: params[:rating])
          respond_to do |format|
            format.html {redirect_to @issue}
            format.js
          end
        end
    end
  end
end
