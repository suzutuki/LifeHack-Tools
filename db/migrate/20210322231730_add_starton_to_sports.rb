class AddStartonToSports < ActiveRecord::Migration[5.2]
  def change
    add_column :sports, :start_on, :float
    add_column :sports, :end_on, :float
  end
end
