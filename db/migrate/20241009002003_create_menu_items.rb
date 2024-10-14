class CreateMenuItems < ActiveRecord::Migration[7.0]
  def change
    create_table :menu_items do |t|
      t.integer :item_id
      t.integer :menu_id
      t.decimal :price

      t.timestamps
    end
  end
end
