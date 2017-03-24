class ExpensesController < ApplicationController

  #
  # index
  #
  def index
    @expenses = Expense.all
  end


end
