class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :handle null false
      t.integer :zip
      t.integer :tweetscount
      t.integer :followerscount
      t.timestamps null: false
    end
  end
end
