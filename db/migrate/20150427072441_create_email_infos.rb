class CreateEmailInfos < ActiveRecord::Migration
  def change
    create_table :email_infos do |t|
      t.string :email
      t.string :field_1
      t.string :field_2
      t.string :field_3
      t.string :field_4
      t.string :field_5

      t.timestamps null: false
    end
  end
end
