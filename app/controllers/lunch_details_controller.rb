class LunchDetailsController < ApplicationController
  def new
    @lunchdetail=LunchDetail.new
  end

  def index
    @lunchdetails=LunchDetail.all
  end

  def create
    params[:lunch_detail][:user_id].each do |user_id|
      @lunchdetail=LunchDetail.new(lunch_detail_params)
      @lunchdetail.user_id = user_id
      @lunchdetail.save
    end
    redirect_to :action => :index
  end

  def show
    @lunchdetail=LunchDetail.find(params[:id])
  end

  def edit
    @lunchdetail=LunchDetail.find(params[:id])
  end

  def update
    @lunchdetail=LunchDetail.find(params[:id])
    if @lunchdetail.update(lunch_detail_params)
      redirect_to @lunchdetail
    else
      render 'edit'
    end
  end

  def destroy
    @lunchdetail=LunchDetail.find(params[:id])
    @lunchdetail.destroy
    redirect_to lunch_details_path
  end

  private
  def lunch_detail_params
    params.require(:lunch_detail).permit(:date, :daily_invoice_id, :had_lunch)
  end
end
