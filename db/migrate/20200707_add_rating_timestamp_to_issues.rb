class AddRatingTimestampToIssues < ActiveRecord::Migration
  def change
  	add_column :issues, :rating_timestamp, :timestamp, :null => false, default: -> { 'NOW()' }
  end
end
