class AddTweetFollowerCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :tweet_count, :integer
    add_column :users, :follower_count, :integer
  end
end
