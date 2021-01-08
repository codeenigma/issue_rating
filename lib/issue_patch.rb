require_dependency 'issue'

# Patches Redmine's Issues dynamically.  Adds a relationship
# Issue +belongs_to+ to Deliverable
module IssuePatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    # Same as typing in the class
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      # Declare 1:n relationship with the user_ratings table.
      has_many :issue_ratings, :foreign_key => 'issue_id'

    end
  end

  module ClassMethods
  end

  module InstanceMethods
    # Wraps the association to get the value of the rating.
    # Needed for the Query and filtering
    def issue_rating_rating_val
      unless self.issue_ratings.first.nil?
        # Return the rating_val of the latest rating for this issue.
        return self.issue_ratings.order(updated_at: :desc).first.rating_val
      end
    end
    # Wraps the association to get the updated date of the rating.
    def issue_rating_updated_at
      unless self.issue_ratings.first.nil?
        # Return the updated_at date of the latest rating for this issue.
        return self.issue_ratings.order(updated_at: :desc).first.updated_at
      end
    end
  end
end


