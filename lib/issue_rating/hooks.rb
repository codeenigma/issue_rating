module IssueRating
	
	class Hooks < Redmine::Hook::ViewListener
    include ActionView::Helpers::TagHelper

    render_on :view_issues_show_description_bottom, :partial => 'issues/issue_rating'

    def view_layouts_base_html_head(context)
      jquery_raty_js = javascript_include_tag("jquery.raty.js", :plugin => 'issue_rating')
      jquery_raty_css = stylesheet_link_tag("jquery.raty.css", :plugin => 'issue_rating')
      snippet = jquery_raty_css  + jquery_raty_js 
   	  return snippet
    end
 	end
end