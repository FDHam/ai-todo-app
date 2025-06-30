class CreateTodos < ActiveRecord::Migration[8.0]
  def change
    create_table :todos do |t|
      t.string :title, null: false, limit: 100
      t.text :description, limit: 500
      t.boolean :completed, null: false, default: false

      t.timestamps
    end

    add_index :todos, :title
    add_index :todos, :completed
    add_index :todos, :created_at
  end
end
