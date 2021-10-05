class CreateWorksheets < ActiveRecord::Migration[5.2]
  def change
    create_table :worksheets do |t|
      t.datetime :session_start
      t.datetime :session_end
      t.text :content
      t.float :worked_hours
      t.boolean :pending_approval
      t.boolean :approved_by_admin
      t.references :employee, foreign_key: true

      t.timestamps
    end
  end
end
