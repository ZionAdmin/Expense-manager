class MealExpensesController < ApplicationController

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

  # def create
  #   params[:lunch_detail][:user_id].each do |user_id|
  #     @lunchdetail = LunchDetail.new(lunch_detail_params)
  #     @lunchdetail.user_id = user_id
  #     @lunchdetail.save
  #   end
  #     redirect_to :action => :index
  # end
  #
  # def update
  #   @lunchdetail = LunchDetail.find(params[:id])
  #   params[:lunch_detail][:user_id].each do |user_id|
  #     @lunchdetail.update(lunch_detail_params)
  #     @lunchdetail.user_id = user_id
  #   end
  #     redirect_to :action => :index
  # end

  #
  # def destroy
  #   @lunchdetail=LunchDetail.find(params[:id])
  #   @lunchdetail.destroy
  #   redirect_to lunch_details_path
  # end

  private
  def lunch_detail_params
    params.require(:lunch_detail).permit(:date, :daily_invoice_id, :had_lunch)
  end
end
