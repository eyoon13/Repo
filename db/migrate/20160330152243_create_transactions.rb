class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :User
      t.timestamps null: false
    end
  end
end
