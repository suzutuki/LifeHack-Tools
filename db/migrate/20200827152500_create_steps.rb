class CreateSteps < ActiveRecord::Migration[5.1]
  def change
    create_table :steps do |t|
      t.references :user, foreign_key: true
      t.date :day
      t.integer :event_id
      t.text :name
      t.string :goal
      t.timestamps
    end
  end
end
