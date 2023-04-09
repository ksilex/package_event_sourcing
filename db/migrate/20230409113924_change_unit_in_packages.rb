class ChangeUnitInPackages < ActiveRecord::Migration[7.0]
  def change
    change_column(:packages, :unit, :string)
  end
end
