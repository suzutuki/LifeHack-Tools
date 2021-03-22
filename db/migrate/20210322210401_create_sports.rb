class CreateSports < ActiveRecord::Migration[5.2]
  def change
    create_table :sports do |t|
      t.references :user, foreign_key: true
      t.date :sport_day
      t.float :sport_time

      t.timestamps
    end
  end
end
