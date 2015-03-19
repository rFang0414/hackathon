class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :previous_id
      t.string :user_phone
      t.string :job_id
      t.string :player

      t.timestamps null: false
    end
  end
end
