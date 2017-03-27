  class DailyInvoicesController < ApplicationController

    #
    # index
    #
    def index
      @daily_invoices = DailyInvoice.paginate(:page => params[:page], :per_page => 15)
      @daily_invoices = @daily_invoices.joins(:expenses).where('expenses.type = ?', params[:type_ids]).uniq if params[:type_ids].present?
      @daily_invoices = @daily_invoices.where('date LIKE ?', Date.parse("%#{params[:date]}%", '%MM-%DD-%YYYY')) if params[:date].present?
    end

    #
    # new
    #
    def new
      @daily_invoice= DailyInvoice.new
      @daily_invoice.expenses.build
    end

    #
    # edit
    #
    def edit
      @daily_invoice = DailyInvoice.find(params[:id])
      @daily_invoice.expenses.build
    end

    #
    # show
    #
    def show
      @daily_invoice= DailyInvoice.find(params[:id])
      @expense_array = Expense.where(daily_invoice_id: @daily_invoice.id)
      user_array = @expense_array.collect {|users| users.user.name}.uniq
      @users = user_array.join(", ")
      date_array = @expense_array.collect {|dates| dates.date}.uniq
      @dates = date_array.join(", ")
    end

    #
    # create
    #
    def create
      @daily_invoice = DailyInvoice.new(daily_invoice_params)
      @daily_invoice.save
      date_array = params[:daily_invoice][:expense][:date].split(',')
      user_ids = params[:daily_invoice][:expense][:user_ids]
      date_array.each do |date|
        user_ids.each do |user_id|
          @expense = Expense.new(daily_invoice_id: @daily_invoice.id, date: date, had_lunch: params[:daily_invoice][:expense][:had_lunch], type: params[:daily_invoice][:expense][:type])
          @expense.user_id = user_id
          @expense.save
        end
      end
      if @expense.save
        redirect_to daily_invoices_path
      else
        redirect_to new_daily_invoice_path
      end
    end

    #
    # update
    #
    def update
      @daily_invoice= DailyInvoice.find(params[:id])
      @daily_invoice.destroy
      @daily_invoice= DailyInvoice.new(daily_invoice_params)
      @daily_invoice.save
      date_array = params[:daily_invoice][:expense][:date].split(',')
      user_ids = params[:daily_invoice][:expense][:user_ids]
      date_array.each do |date|
        user_ids.each do |user_id|
          @expense = Expense.new(daily_invoice_id: @daily_invoice.id, date: date, had_lunch: params[:daily_invoice][:expense][:had_lunch], type: params[:daily_invoice][:expense][:type])
          @expense.user_id = user_id
          @expense.save
        end
      end
      if @expense.save
        redirect_to daily_invoices_path
      else
        redirect_to edit_daily_invoice_path
      end
    end

    #
    # destroy
    #
    def destroy
      @daily_invoice= DailyInvoice.find(params[:id])
      @daily_invoice.destroy
      redirect_to daily_invoices_url
    end

    #
    # daily_details
    #
    def daily_details
      @daily_invoices = DailyInvoice.where("date = ?", params['date'])
      if request.post?
        if params['date'].blank?
          @date_error = true
          @date_error_message = "No records found"
        elsif @daily_invoices.blank?
          @date_error = true
          @date_error_message = "No records found"
        else
          @vardate=params['date']
        end
      end
      @total_amount = []
      total_amount_calculation = Expense.where("expenses.date =? AND had_lunch = ?",@vardate,true)
      total_amount_calculation.each do |lunch_detail|
        @total_amount << lunch_detail.user.cost_of_meal
      end
      @total_amount = @total_amount.sum
    end
    private
    def daily_invoice_params
      params.require(:daily_invoice).permit(:restaurant_name, :amount, :date, :image, :price, expenses_attributes: [:id, :daily_invoice_id, :date, :had_lunch, :type, user_id: []])
    end
  end

