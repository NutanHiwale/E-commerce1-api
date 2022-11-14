class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :desc
      t.string :category
      t.string :price
      t.string :quantity
      t.timestamps
    end
  end
end
