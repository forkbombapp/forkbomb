class CreateForks < ActiveRecord::Migration
  def change
    create_table :forks do |t|
      t.string :user
      t.string :repo_name

      t.timestamps
    end
  end
end
