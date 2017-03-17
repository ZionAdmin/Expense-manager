class DailyInvoicesController < ApplicationController

  def new
    @dailyinvoice = DailyInvoice.new
    @dailyinvoice.build_lunch_detail
  end

  def index
    @dailyinvoices = DailyInvoice.order('created_at')
  end

  def create
   DailyInvoice.save_lunch_details# = LunchDetail.new(:daily_invoice_id => @dailyinvoice.id, :date => @dailyinvoice.date, :had_lunch => params[:daily_invoice][:lunch_detail][:had_lunch])
   redirect_to :action => :index
  end

  def edit
    @dailyinvoice=DailyInvoice.find(params[:id])
  end

  def show
    redirect_to :action => :daily_details
    @dailyinvoice=DailyInvoice.find(params[:id])
  end

  def update
    @dailyinvoice=DailyInvoice.find(params[:id])
    if @dailyinvoice.update(daily_invoice_params)

      redirect_to @dailyinvoice
    else
      render 'edit'
    end
  end

  def destroy
    @dailyinvoice=DailyInvoice.find(params[:id])
    @dailyinvoice.destroy
    redirect_to daily_invoices_path
  end

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

