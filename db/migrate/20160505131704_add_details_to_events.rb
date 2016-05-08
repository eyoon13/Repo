class AddDetailsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :start_time, :datetime
    add_column :events, :name, :string
    add_column :events, :location, :string
  end
end
