require_dependency 'query'

# Patches Redmine's Queries dynamically, adding the IssueRating value and
# timestamp to the available query columns.
module IssueQueryPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    # Same as typing in the class
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development

      # @TODO: Add columns to issue listings for users with global permissions.
      #if User.current.allowed_to?(:update_rating, nil, :global => true)

      # Prepare SQL query for adding sortable columns.
      subselect = "SELECT %s FROM #{IssueRating.table_name}" +
      " WHERE #{IssueRating.table_name}.issue_id = #{Issue.table_name}.id" +
      " ORDER BY #{IssueRating.table_name}.updated_at DESC" +
      " LIMIT 1"
      # Add column for rating value 'rating_val'.
      base.add_available_column(QueryColumn.new(:issue_rating_rating_val,
        :sortable => "COALESCE((" + sprintf(subselect, "rating_val") + "), 0)",
        :default_order => 'desc',
        :caption => :label_issue_rating_rating_val
        #:totalable => true
      ))
      # Add column faor rating timestamp 'updated_at'.
      base.add_available_column(QueryColumn.new(:issue_rating_updated_at,
        :sortable => "COALESCE((" + sprintf(subselect, "updated_at") + "), 0)",
        :default_order => 'desc',
        :caption => :label_issue_rating_updated_at
      ))

      alias_method :redmine_available_filters, :available_filters
      alias_method :available_filters, :issue_rating_available_filters
    end

    # Filter 'issue_rating_rating_val' field SQL callback.
    def sql_for_issue_rating_rating_val_field(field, operator, value)
      case operator
      when "=", ">=", "<=", "!*", "><"
        sw = ''
        nl = ''
        if operator == "!*"
          sw = 'NOT'
        elsif operator == "><"
          nl = "AND ir1.rating_val >= #{value.first} AND ir1.rating_val <= #{value[1]}"
        else
          nl = "AND ir1.rating_val #{operator} #{value.first}"
        end

        "( #{Issue.table_name}.id #{sw} IN (SELECT ir1.issue_id FROM #{IssueRating.table_name} ir1" +
        " LEFT JOIN #{IssueRating.table_name} ir2 ON (ir1.issue_id = ir2.issue_id AND ir1.updated_at < ir2.updated_at)" +
        " WHERE ir2.issue_id IS NULL #{nl}) )"

      end
    end

    # Filter 'issue_rating_updated_at' field SQL callback.
    def sql_for_issue_rating_updated_at_field(field, operator, value)
      sql = sql_for_field(field, operator, value, "ir1", "updated_at", false)

      "( #{Issue.table_name}.id IN (SELECT ir1.issue_id FROM #{IssueRating.table_name} ir1" +
      " LEFT JOIN #{IssueRating.table_name} ir2 ON (ir1.issue_id = ir2.issue_id AND ir1.updated_at < ir2.updated_at)" +
      " WHERE ir2.issue_id IS NULL AND #{sql} ) )"

    end

  end

  module ClassMethods
  end

  module InstanceMethods
    # Wrapper around the +available_filters+ to add issue_rating filters
    def issue_rating_available_filters
      @available_filters = redmine_available_filters

      # @TODO: Add columns to issue listings for users with global permissions.
      #if User.current.allowed_to?(:update_rating, nil, :global => true)

      if project
        issue_rating_filters = {
          "issue_rating_rating_val" => QueryFilter.new("rating_val", { :type => :integer, :name => l(:label_issue_rating_rating_val) }),
          "issue_rating_updated_at" => QueryFilter.new("rating_updated_at", { :type => :date_past, :name => l(:label_issue_rating_updated_at) })
        }
      else
        issue_rating_filters = { }
      end
      return @available_filters.merge(issue_rating_filters)
    end
  end
end
