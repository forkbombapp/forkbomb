class AddGithubMetadataToForks < ActiveRecord::Migration
  def change
    add_column :forks, :parent, :string
    add_column :forks, :behind_by, :integer
    add_column :forks, :parent_default_branch, :string
    add_column :forks, :default_branch, :string
    add_column :forks, :parent_repo_name, :string
  end
end
