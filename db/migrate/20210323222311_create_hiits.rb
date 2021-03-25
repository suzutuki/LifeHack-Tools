class CreateHiits < ActiveRecord::Migration[5.2]
  def change
    create_table :hiits do |t|
      t.references :user, foreign_key: true
      t.date :training_day
      t.integer :training_time
      t.text :content
      t.timestamps
    end
  end
end
