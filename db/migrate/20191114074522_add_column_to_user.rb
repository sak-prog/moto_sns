class AddColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    add_column :users, :introduce, :text
    add_column :users, :motorcycle, :text
    add_index :users, :name
    add_index :users, :introduce
    add_index :users, :motorcycle
  end
end
