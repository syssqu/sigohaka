class RemoveCodeNameToProjects < ActiveRecord::Migration
  def up
    remove_column :projects, :code
    remove_column :projects, :name
    add_column :projects, :term, :integer
  end

  def down
    add_column :projects, :code, :string
    add_column :projects, :name, :string
    remove_column :projects, :term
  end
end
