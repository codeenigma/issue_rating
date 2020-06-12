require_dependency 'issue_rating/hooks'
require_dependency 'issue_rating/issue_model_patch'


# Patch issue_query to allow columns for ratings.
issue_query = (IssueQuery rescue Query)
issue_query.add_available_column(QueryColumn.new(:rating, :sortable => "#{Issue.table_name}.rating", :default_order => 'desc'))

# Register Redmine plugin: issue_rating.
Redmine::Plugin.register :issue_rating do
  name 'Issue Rating plugin'
  author 'Code Enigma'
  description 'Redmine customer satisfaction rating plugin'
  version '0.0.1-alpha'
  url 'http://redmine.codeenigma.net'
  author_url 'https://www.codeenigma.com/about-us'

  requires_redmine  :version_or_higher => '3.4.1'

  # Ability to enable module per project (in settings/modules).
  project_module :issue_rating do
    # Global permissions and per project.
    permission :rate_issue, { :issue_rating => :update_rating }, :require => :loggedin
  end

  Rails.configuration.to_prepare do
    Issue.send(:include, IssueModelPatch)
  end
end
