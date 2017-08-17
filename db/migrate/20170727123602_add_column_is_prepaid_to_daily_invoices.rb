class AddColumnIsPrepaidToDailyInvoices < ActiveRecord::Migration[5.0]
  def change
  add_column :daily_invoices, :is_prepaid, :boolean 
 end
end
