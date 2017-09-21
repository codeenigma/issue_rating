require_dependency 'issue_rating/hooks'
require_dependency 'issue_rating/issue_model_patch'
require_dependency 'issue_rating/issue_controller_patch'
Redmine::Plugin.register :issue_rating do
  name 'Issue Rating plugin'
  author 'Amir Musin'
  description 'Plugin for adding issue rating'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  Rails.configuration.to_prepare do 
    # This tells the Redmine version's controller to include the module from the file above.
    Issue.send(:include, IssueModelPatch)
    IssuesController.send(:include, IssueControllerPatch)
  end
end
