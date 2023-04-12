class AddCompanyToPackages < ActiveRecord::Migration[7.0]
  def change
    add_column :packages, :company, :string
  end
end
