module IssueRatingHooks

	class Hooks < Redmine::Hook::ViewListener
    include ActionView::Helpers::TagHelper

    render_on :view_issues_show_description_bottom, :partial => 'issues/issue_rating'

    def view_layouts_base_html_head(context)
      # Check whether the project object exists.
      project = context[:project] || return
      return if project.nil?
      # Load JS/CSS only if user has permissions and module enabled in project.
      # @TODO: Add 'if' condition on issue statuses: currently, assets are
      # loaded no matter which statuses are allowed.
      if project.module_enabled?(:issue_rating) && User.current.allowed_to?(:rate_issue, project)
        # Add jquery.raty JS/CSS and application CSS to the page.
        jquery_raty_js = javascript_include_tag("jquery.raty.js", :plugin => 'issue_rating')
        jquery_raty_css = stylesheet_link_tag("jquery.raty.css", :plugin => 'issue_rating')
        application_css = stylesheet_link_tag("application.css", :plugin => 'issue_rating')
        snippet = jquery_raty_css  + jquery_raty_js + application_css
        return snippet
      end
    end
  end
end
