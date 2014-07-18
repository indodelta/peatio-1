class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.decimal :amount
      t.string :currency
      t.integer :member_id

      t.timestamps
    end
  end
end
