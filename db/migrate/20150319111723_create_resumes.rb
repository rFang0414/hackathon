class CreateResumes < ActiveRecord::Migration
  def change
    create_table :resumes do |t|
      t.string :name
      t.string :email
      t.string :city
      t.string :experience_year
      t.string :school_name
      t.string :company_name
      t.string :degree
      t.string :phone_number
      t.date :school_start_date
      t.date :school_end_date
      t.date :work_start_date
      t.date :work_end_date

      t.timestamps null: false
    end
  end
end
