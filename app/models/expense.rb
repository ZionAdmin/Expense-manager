  class Expense < ApplicationRecord
    # has_one :daily_invoice
    belongs_to :daily_invoice
    belongs_to :user
    validate :user_id
    acts_as_paranoid
    default_scope { where(deleted_at: nil) }
    EXPENSE_TYPES = ["MealsExpense", "FruitsExpense", "SnaksExpense"]



    #
    #search
    #
    def self.search(search)
      if search
        Expense.joins(:user).joins(:daily_invoice).where('users.name LIKE ? OR daily_invoices.restaurant_name LIKE ? OR type LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
      else
        Expense.all
      end
    end
  end

