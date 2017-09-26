class RenameColumnInExpenses < ActiveRecord::Migration[5.0]
  def change
  rename_column :expenses, :invoice_id, :daily_invoice_id
  end
end
