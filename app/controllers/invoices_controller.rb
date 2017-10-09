class InvoicesController < ApplicationController
  require 'date'

  #
  # index
  #
  def index
    @invoices = Invoice.all
    @custom_expense_type_all = CustomExpenseType.all.collect{|c| c.name }
    #binding.pry
    if(params[:type_ids].present? && ((params[:type_ids].keys).all? {|e| (Expense::TYPES).include?(e)}))
      @invoices = @invoices.joins(:expenses).where('expenses.type in (?)', (params[:type_ids].keys)).distinct
    elsif(params[:type_ids].present? && ((params[:type_ids].keys).all? {|e| (Expense::TYPES).exclude?(e)}))
      @custom_exp_type_obj = CustomExpenseType.where("name in (?)", params[:type_ids].keys)
      @invoices = @invoices.joins(:expenses).where('expenses.custom_expense_type_id in (?)', (@custom_exp_type_obj.ids)).distinct
    end
    @invoices = @invoices.where('invoices.date=?', "#{params[:date]}") if params[:date].present?
    @invoices = @invoices.paginate(:page => params[:page], :per_page => 15)
  end

  #
  # new
  #
  def new
    @custom_expense_type = CustomExpenseType.new
    @custom_expense_type_all = CustomExpenseType.all
    @invoice = Invoice.new
    @invoice.expenses.build
  end

  #
  # edit
  #
  def edit
    @invoice = Invoice.find(params[:id])
    @custom_expense_type_all = CustomExpenseType.all
    @invoice.expenses
  end

  #
  # show
  #
  def show
    @invoice = Invoice.find(params[:id])
    @expense_array = Expense.where(invoice_id: @invoice.id)
    user_array = @expense_array.collect {|users| users.user.name}.uniq
    @users = user_array.join(", ")
    date_array = @expense_array.collect {|dates| dates.date.strftime("%d-%m-%Y")}.uniq
    @dates = date_array.join(", ")
  end

  #
  # create
  #
  def create
    @invoice = Invoice.new(invoice_params)
    @invoice.save

    date_array = params[:invoice][:expense][:date].split(',')
    user_ids = params[:invoice][:expense][:user_ids]

    date_array.each do |date|

      user_ids.each do |user_id|

        @expense = Expense.new(invoice_id: @invoice.id, date: date, had_lunch: params[:invoice][:expense][:had_lunch])

         default_expense_types = ["MealsExpense", "FruitsExpense", "SnaksExpense"]

        if(default_expense_types.include? params[:invoice][:expense][:type])
          @expense.type = params[:invoice][:expense][:type]
        else
          @expense.type = "CustomExpense"
          @expense.custom_expense_type_id = params[:invoice][:expense][:type]
        end
        @expense.user_id = user_id
        @expense.save
      end
    end
    if @expense.save
      redirect_to invoices_path
    else
      redirect_to new_invoice_path
    end
  end

  #
  # update
  #
  def update
    @invoice = Invoice.find(params[:id])

    date_array = params[:invoice][:expense][:date].split(',')
    user_ids = params[:invoice][:expense][:user_ids]

    date_array.each do |date|
      
      user_ids.each do |user_id|
        
        @expense = @invoice.expenses
        @expense = @expense.update(invoice_id: params[:id], date: date, had_lunch: params[:invoice][:expense][:had_lunch], type: params[:invoice][:expense][:type])
        # @expense.update :user_id => user_id
      end
    end
    @invoice = @invoice.update(invoice_params)
    redirect_to invoices_path
  end

  #
  # destroy
  #
  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy
    redirect_to invoices_url
  end

  #
  # daily_details
  #
  def daily_details
    @invoices = Invoice.where("date = ?", params['date'])
    if request.post?
      if params['date'].blank?
        @date_error = true
        @date_error_message = "No records found"
      elsif @invoices.blank?
        @date_error = true
        @date_error_message = "No records found"
      else
        @vardate=params['date']
      end
    end
    @total_amount = []
    total_amount_calculation = Expense.where("expenses.date =? AND had_lunch = ?", @vardate, true)
    total_amount_calculation.each do |lunch_detail|
      @total_amount << lunch_detail.user.cost_of_meal
    end
    @total_amount = @total_amount.sum
  end

  def previous_record
    @invoice = Invoice.last
    @expenses = @invoice.expenses
    @users =[]
    @expenses.each do |exp|
      @users << exp.user
    end
    respond_to do |format|
      format.js
    end
  end
  private

  #
  # invoice_params
  #
  def invoice_params
    params.require(:invoice).permit(:restaurant_name, :amount, :is_prepaid, :date, :image, :price, expense_attributes: [:id, :invoice_id, :date, :had_lunch, :type, user_id: []])
  end
end

