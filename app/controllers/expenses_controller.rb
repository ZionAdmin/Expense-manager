class ExpensesController < ApplicationController

  #
  # index
  #
  def index

  end

  #
  # new
  #
  def new

  end

  #
  # edit
  #
  def edit

  end

  #
  # show
  #
  def show

  end

  #
  # create
  #
  def create

  end

  #
  # update
  #
  def update

  end

  #
  # destroy
  #
  def destroy

  end

  def imports
    @response = Expense.import_data(params[:file],params[:user_suffix], params[:company_suffix])

  end

  private

  #
  # daily_invoice_params
  #
  def daily_invoice_params

  end
end
