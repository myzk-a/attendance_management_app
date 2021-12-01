class AddSignupToWorks < ActiveRecord::Migration[5.1]
  def change
    add_column :works, :signup, :boolean, default: false
  end
end
