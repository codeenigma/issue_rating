class AddRatingToIssues < ActiveRecord::Migration
  def change
  	add_column :issues, :rating, :integer
  end
end
