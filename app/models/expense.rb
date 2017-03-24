  class Expense < ApplicationRecord
    # has_one :daily_invoice
    belongs_to :daily_invoice
    belongs_to :user
    validate :user_id

  end

