class CreateApiPerformances < ActiveRecord::Migration
  def change
    create_table :api_performances do |t|
      t.string :api_name
      t.string :api_time

      t.timestamps null: false
    end
  end
end
