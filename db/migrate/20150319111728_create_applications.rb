class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.string :job_id
      t.string :node_id
      t.string :resume_id

      t.timestamps null: false
    end
  end
end
