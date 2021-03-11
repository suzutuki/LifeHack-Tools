class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists do |t|
      t.references :user, foreign_key: true
      t.text :answer
      t.boolean :done
      t.text :event
      t.text :respect
      t.text :disdain
      t.text :boss
      t.text :guidance
      t.text :question
      t.timestamps
    end
  end
end
