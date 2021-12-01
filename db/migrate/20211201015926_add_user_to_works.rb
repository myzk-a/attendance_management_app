class AddUserToWorks < ActiveRecord::Migration[5.1]
  def change
    add_reference :works, :user, index: true, foreign_key: true
  end
end
