class CustomExpenseType < ApplicationRecord
 acts_as_paranoid
 has_many :custom_expenses
end
