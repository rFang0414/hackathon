class AddStatusToEmailInfo < ActiveRecord::Migration
  def change
    add_column :email_infos, :status, :string
  end
end
