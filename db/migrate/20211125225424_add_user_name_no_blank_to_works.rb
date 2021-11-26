class AddUserNameNoBlankToWorks < ActiveRecord::Migration[5.1]
  def change
    add_column :works, :user_name_no_blank, :string
  end
end
