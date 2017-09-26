class RenameColumnInExpenses < ActiveRecord::Migration[5.0]
  def change
  rename_column :expenses, :daily_invoice_id, :invoice_id
  end
end
