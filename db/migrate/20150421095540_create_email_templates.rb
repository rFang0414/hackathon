class CreateEmailTemplates < ActiveRecord::Migration
  def change
    create_table :email_templates do |t|
      t.string :email_name
      t.text :email_html

      t.timestamps null: false
    end
  end
end
