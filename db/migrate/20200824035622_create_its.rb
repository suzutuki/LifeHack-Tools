class CreateIts < ActiveRecord::Migration[5.1]
  def change
    create_table :its do |t|
      t.references :user, foreign_key: true
      t.text :situation
      t.text :behavior

      t.timestamps
    end
  end
end
