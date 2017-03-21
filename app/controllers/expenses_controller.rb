class ExpensesController < ApplicationController

  #
  # index
  #
  def index
    @expenses = Expense.all
  end

  #
  # new
  #
  def new
    @dailyinvoice = DailyInvoice.new
    @dailyinvoice.expenses.build
  end

  #
  # edit
  #
  def edit
    @dailyinvoice = DailyInvoice.find(params[:id])
    @dailyinvoice.expenses.build
  end

  #
  # create
  #
  def create
    @dailyinvoice = DailyInvoice.new(daily_invoice_params)
    @dailyinvoice.save
    user_ids = params[:daily_invoice][:expense][:user_ids]
    type = params[:daily_invoice][:expense][:type]
    had_lunch = params[:daily_invoice][:expense][:had_lunch]
    unless user_ids.nil?
      user_ids.each do |user_id|
        @expense = Expense.new(daily_invoice_id: @dailyinvoice.id, date: @dailyinvoice.date, had_lunch: had_lunch, type: type)
        @expense.user_id = user_id
        @expense.save
      end
    end
    if @expense.save
      redirect_to expenses_url
    else
      redirect_to new_expense_path
    end
  end

  #
  # update
  #
  def update
    @dailyinvoice = DailyInvoice.find(params[:id])
    @dailyinvoice.destroy
    @dailyinvoice = DailyInvoice.new(daily_invoice_params)
    @dailyinvoice.save
    type = params[:daily_invoice][:expense][:type]
    had_lunch = params[:daily_invoice][:expense][:had_lunch]
    unless user_ids.nil?
      user_ids.each do |user_id|
        @expense = Expense.new(daily_invoice_id: @dailyinvoice.id, date: @dailyinvoice.date, had_lunch: had_lunch, type: type)
        @expense.user_id = user_id
        @expense.save
      end
    end
    if @expense.save
      redirect_to expenses_url
    else
      redirect_to new_expense_path
    end
  end

  #
  # destroy
  #
  def destroy
    @dailyinvoice = DailyInvoice.find(params[:id])
    @dailyinvoice.destroy
    redirect_to expenses_url
  end

  private
  def daily_invoice_params
    params.require(:daily_invoice).permit(:restaurant_name, :amount, :date, :image, :price, expenses_attributes: [:id, :daily_invoice_id, :date, :had_lunch, :type, user_id: []])
  end
end
