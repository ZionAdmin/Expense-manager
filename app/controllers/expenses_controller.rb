class ExpensesController < ApplicationController

  #
  # index
  #
  def index
    @expenses = Expense.paginate(:page => params[:page], :per_page => 15)
    @expenses = @expenses.joins(:user).user(params[:user_ids]) if params[:user_ids].present?
    @expenses = @expenses.expense_types(params[:type_ids]) if params[:type_ids].present?
    @expenses = @expenses.where('date LIKE ?', Date.parse("%#{params[:date]}%", '%MM-%DD-%YYYY')) if params[:date].present?
    @expenses = Expense.paginate(:page => params[:page], :per_page => 15).search(params[:search]).order("created_at DESC") if params[:search].present?
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
  # show
  #
  def show
    @expense = Expense.find(params[:id])
    # @dailyinvoice.expenses
  end

  #
  # create
  #
  def create
    @dailyinvoice = DailyInvoice.new(daily_invoice_params)
    @dailyinvoice.save
    date_array = params[:daily_invoice][:expense][:date].split(',')
    user_ids = params[:daily_invoice][:expense][:user_ids]
      date_array.each do |date|
        user_ids.each do |user_id|
          @expense = Expense.new(daily_invoice_id: @dailyinvoice.id, date: date, had_lunch: params[:daily_invoice][:expense][:had_lunch], type: params[:daily_invoice][:expense][:type])
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
    date_array = params[:daily_invoice][:expense][:date].split(',')
    user_ids = params[:daily_invoice][:expense][:user_ids]
    date_array.each do |date|
      user_ids.each do |user_id|
        @expense = Expense.new(daily_invoice_id: @dailyinvoice.id, date: date, had_lunch: params[:daily_invoice][:expense][:had_lunch], type: params[:daily_invoice][:expense][:type])
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
