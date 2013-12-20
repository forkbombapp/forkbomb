class RenameForkUserToOwner < ActiveRecord::Migration
  def change
    rename_column :forks, :user, :owner
  end
end