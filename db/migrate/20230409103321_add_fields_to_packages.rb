class AddFieldsToPackages < ActiveRecord::Migration[7.0]
  def change
    add_column :packages, :location, :jsonb
    add_column :packages, :time, :datetime
  end
end
