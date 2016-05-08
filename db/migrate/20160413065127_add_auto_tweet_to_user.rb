class AddAutoTweetToUser < ActiveRecord::Migration
  def change
    add_column :users, :auto_tweet, :boolean
  end
end
