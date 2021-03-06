class CreateApplicants < ActiveRecord::Migration
  def change
    create_table :applicants do |t|
      t.string :first_name
      t.string :last_name
      t.string :region
      t.string :phone
      t.string :email
      t.string :phone_type
      t.string :source
      t.boolean :over_21
      t.text :reason
      t.string :workflow_state

      t.timestamps null: false
    end
    add_index :applicants, :email, unique: true
    add_index :applicants, :phone, unique: true
    add_index :applicants, :created_at
    add_index :applicants, :workflow_state
  end
end
