class RenamingDailyInvoicesToInvoices < ActiveRecord::Migration[5.0]
  def change
    rename_table :daily_invoices, :invoices
  end
end
