class AddRatingToIssues < ActiveRecord::Migration
  def change
  	add_column :issues, :rating, :integer, :default => 0
  end
end
