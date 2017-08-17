class CreateCustomExpenseTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :custom_expense_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
