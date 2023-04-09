class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.string :phone
      t.string :email
      t.string :enabled
      t.references :package, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
