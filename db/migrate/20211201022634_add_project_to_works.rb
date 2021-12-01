class AddProjectToWorks < ActiveRecord::Migration[5.1]
  def change
    add_reference :works, :project, index: true, foreign_key: true
  end
end
