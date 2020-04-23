class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.boolean :done
      t.text :content
      t.references :user, foreign_key: true
      
      t.timestamps
    end
    add_index :tasks, [:user_id, :created_at]
  end
end
