class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :job_title
      t.text :job_description
      t.string :required_experience
      t.text :job_requirement
      t.string :job_type
      t.string :address
      t.integer :salary
      t.string :company_name
      t.string :city
      t.string :state

      t.timestamps null: false
    end
  end
end
