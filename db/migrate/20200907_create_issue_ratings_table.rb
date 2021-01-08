# @TODO: Write comment on table structure.
class CreateIssueRatingsTable < ActiveRecord::Migration
    def self.up
    create_table :issue_ratings do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.references :issue, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer :rating_val
    end
    # add_index :issue_ratings, [:issue_id, :user_id], unique: true
  end


  def self.down
    drop_table :issue_ratings
  end
end
