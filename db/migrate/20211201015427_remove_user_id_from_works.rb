class RemoveUserIdFromWorks < ActiveRecord::Migration[5.1]
  def change
    remove_column :works, :user_id, :integer
  end
end
