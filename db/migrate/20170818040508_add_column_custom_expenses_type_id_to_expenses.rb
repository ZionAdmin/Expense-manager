class AddColumnCustomExpensesTypeIdToExpenses < ActiveRecord::Migration[5.0]
  def change
    add_column :expenses, :custom_expense_type_id, :integer
  end
end
