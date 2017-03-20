class DailyInvoicesController < ApplicationController

  #
  # new
  #
  def new
    @dailyinvoice = DailyInvoice.new
    @dailyinvoice.expenses.build
  end

  #
  # index
  #
  def index
    @dailyinvoices = DailyInvoice.order('created_at')
  end

  #
  # create
  #
  def create
    @dailyinvoice = DailyInvoice.new(daily_invoice_params)
    @dailyinvoice.save
    user_ids = params[:daily_invoice][:expense][:user_ids]
    unless user_ids.nil?
    user_ids.each do |user_id|
      @mealexpense = MealExpense.new(daily_invoice_id: @dailyinvoice.id, date: @dailyinvoice.date, had_lunch: params[:daily_invoice][:expense][:had_lunch])
      @mealexpense.user_id = user_id
      @mealexpense.save
    end
    end
    if @mealexpense.save
      redirect_to :action => :index
    else
      render 'new'
    end
  end

  #
  # edit
  #
  def edit
    @dailyinvoice=DailyInvoice.find(params[:id])
    @dailyinvoice.expenses.build
  end

  #
  # show
  #
  # def show
  #   redirect_to :action => :daily_details
  #   @dailyinvoice=DailyInvoice.find(params[:id])
  # end

  #
  # update
  #
  def update
    @dailyinvoice=DailyInvoice.find(params[:id])
    @dailyinvoice.update(daily_invoice_params)
    user_ids = params[:daily_invoice][:expense][:user_ids]
    unless user_ids.nil?
      user_ids.each do |user_id|
        puts user_id
        @mealexpense = MealExpense.update(daily_invoice_id: @dailyinvoice.id, date: @dailyinvoice.date, had_lunch: params[:daily_invoice][:expense][:had_lunch])
        @mealexpense.user_id = user_id
      end
    end
    if @mealexpense.update
      redirect_to expenses_path
    else
      render 'edit'
    end
  end

  #
  # destroy
  #
  def destroy
    @dailyinvoice=DailyInvoice.find(params[:id])
    @dailyinvoice.destroy
    redirect_to expenses_path
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
    total_amount_calculation = LunchDetail.where("lunch_details.date =? AND had_lunch = ?", @vardate, true)
    total_amount_calculation.each do |lunch_detail|
      @total_amount << lunch_detail.user.cost_of_meal
    end
    @total_amount = @total_amount.sum
  end

  private
  def daily_invoice_params
    params.require(:daily_invoice).permit(:restaurant_name, :amount, :date, :image, :price)
  end
end

