class RemoveProjectIdFromWorks < ActiveRecord::Migration[5.1]
  def change
    remove_column :works, :project_id, :integer
  end
end
