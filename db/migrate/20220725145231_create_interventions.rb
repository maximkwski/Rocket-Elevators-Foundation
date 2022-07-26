class CreateInterventions < ActiveRecord::Migration[5.2]
  def change
    create_table :interventions do |t|
      t.integer :author_id
      t.integer :customer_id
      t.integer :building_id
      t.integer :battery_id
      t.integer :column_id
      t.integer :elevator_id
      t.integer :employee_id
       
      t.datetime :start_date
      t.datetime :end_date
      
      t.string :result, default: "Incomplete"
      t.text :report
      t.string :status, default: "Pending"

      t.timestamps
    end
  end
end
