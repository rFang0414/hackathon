class AddColumToResume < ActiveRecord::Migration
  def change
    add_column :resumes, :job_brief_description, :text
    add_column :resumes, :school_brief_description, :text
  end
end
