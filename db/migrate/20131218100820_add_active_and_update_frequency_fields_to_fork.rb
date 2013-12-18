class AddActiveAndUpdateFrequencyFieldsToFork < ActiveRecord::Migration
  def change
    add_column :forks, :active, :boolean
    add_column :forks, :update_frequency, :string
  end
end
