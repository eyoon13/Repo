class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :events, :User_id, :user_id
    rename_column :transactions, :User_id, :user_id
  end
end
