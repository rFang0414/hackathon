class AddColumToResume2 < ActiveRecord::Migration
  def change
    add_column :resumes, :position_title, :string
  end
end
