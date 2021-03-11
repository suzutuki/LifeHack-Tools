class AddDonesToSteps < ActiveRecord::Migration[5.2]
  def change
    add_column :steps, :done, :boolean
  end
end
