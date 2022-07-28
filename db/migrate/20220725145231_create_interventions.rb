class CreateInterventions < ActiveRecord::Migration[5.2]
  def change
    create_table :interventions do |t|
      t.integer :author_id
      t.integer :customer_id, null: false
      t.integer :building_id, null: false
      t.integer :battery_id, null: false
      t.integer :column_id, null: true
      t.integer :elevator_id, null: true
      t.integer :employee_id, null: true
       
      t.datetime :start_date
      t.datetime :end_date
      
      t.string :result, default: "Incomplete"
      t.text :report
      t.string :status, default: "Pending"

      t.timestamps
    end
  end
end
