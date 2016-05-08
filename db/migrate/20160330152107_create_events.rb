class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :User
      t.timestamps null: false
    end
  end
end
