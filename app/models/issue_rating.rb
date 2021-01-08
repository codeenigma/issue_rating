# A rating is an item that is created as part of an issue.  These items contain
# an integer value submitted by a user with a timestamp for a given issue.
class IssueRating < ActiveRecord::Base
  unloadable
  # Validate the value submitted for the rating is between 0 and 5.
  validates_inclusion_of :rating_val, :in => 0..5, :allow_nil => true

  # Declare a 1:n relationship with the issues and ussers tables.
  belongs_to :issue
  belongs_to :user

end
