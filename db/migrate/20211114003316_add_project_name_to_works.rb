class AddProjectNameToWorks < ActiveRecord::Migration[5.1]
  def change
    add_column :works, :project_name, :string
    add_column :works, :project_code, :string
  end
end
