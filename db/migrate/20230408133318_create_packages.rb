class CreatePackages < ActiveRecord::Migration[7.0]
  def change
    create_table :packages, id: :uuid do |t|
      t.string :track_id
      t.string :status, default: 'registered'
      t.references :user, null: false, foreign_key: true
      t.decimal :unit
      t.decimal :weight

      t.timestamps
    end
  end
end
