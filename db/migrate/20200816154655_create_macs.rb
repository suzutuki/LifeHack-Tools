class CreateMacs < ActiveRecord::Migration[5.1]
  def change
    create_table :macs do |t|
      t.references :user, foreign_key: true
      t.text :measurable
      t.text :actionable
      t.text :competent

      t.timestamps
    end
  end
end
