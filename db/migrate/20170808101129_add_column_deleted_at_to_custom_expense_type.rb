class AddColumnDeletedAtToCustomExpenseType < ActiveRecord::Migration[5.0]
  def change
    add_column :custom_expense_types, :deleted_at, :datetime
    add_index :custom_expense_types, :deleted_at

  end
end
