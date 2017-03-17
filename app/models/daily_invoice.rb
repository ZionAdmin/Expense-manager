  class DailyInvoice < ApplicationRecord
    has_one :lunch_detail
    #belongs_to :user
    validates_presence_of :restaurant_name
    validates_presence_of :amount
    validates_presence_of :date
    has_attached_file :image
    validates_attachment :image, :content_type => { :content_type => ["image/jpeg","image/gif","image/png"] }
    #accepts_nested_attributes_for :lunch_details

      def self.save_lunch_details
          @dailyinvoice = DailyInvoice.new(params[:daily_invoice].permit(:restaurant_name, :amount, :date, :image, :price))
          @dailyinvoice.save
          user_ids = params[:daily_invoice][:lunch_detail][:user_id]
          user_ids.each do |user_id|
              @lunchdetail = LunchDetail.new(:daily_invoice_id => @dailyinvoice.id, :date => @dailyinvoice.date, :had_lunch => params[:daily_invoice][:lunch_detail][:had_lunch])
              @lunchdetail.user_id = user_id
              @lunchdetail.save
          end
      end
  end
