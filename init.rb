require 'redmine'
# dependencies in lib.
require_dependency 'hooks'
require_dependency 'issue_patch'
require_dependency 'issue_query_patch'

# Register Redmine plugin: issue_rating.
Redmine::Plugin.register :issue_rating do
  name 'Issue Rating plugin'
  author 'Code Enigma'
  description 'Redmine 5 stars customer satisfaction rating plugin'
  version '0.0.1'
  url 'http://redmine.codeenigma.net'
  author_url 'https://www.codeenigma.com/about-us'

  requires_redmine  :version_or_higher => '3.4.1'

  # Declare plugin admin configuration settings.
  settings :default => {'issue_rating_statuses' => ''},
           :partial => 'settings/issue_rating_settings'

  # Ability to enable module per project (in settings/modules).
  project_module :issue_rating do
    # Global permissions and per project.
    permission :rate_issue, { :issue_rating => :update_rating }, :require => :loggedin
  end

  Rails.configuration.to_prepare do
    Issue.send(:include, IssuePatch)
    IssueQuery.send(:include, IssueQueryPatch)
  end
end
