class RatingsController < ApplicationController
  unloadable


  def update_rating
  	@issue = Issue.find(params[:id])
      if @issue.update_attributes(rating: params[:rating])
        respond_to do |format|
    	    format.html {redirect_to @issue}
          format.js
        end
      end
  end
end
