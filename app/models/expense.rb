class Expense < ApplicationRecord
  acts_as_paranoid

  belongs_to :invoice
  belongs_to :user

  validate :user_id

  default_scope {where(deleted_at: nil)}

  TYPES = ["MealsExpense", "FruitsExpense", "SnaksExpense", "CustomExpense"]
  HEADERS = ["Date","Cost of Meal","SZ_sp","TOTAL","Pending to Spend"]

  #
  # import_data
  #
  # params {FILE} file
  def self.import_data(file, type = "MealsExpense", user_suffix, company_suffix)
    row_hash = Hash.new
    header_hash = Hash.new
    begin
      CSV.foreach(file.path, headers: true).with_index do |row, index|
        row_hash = row.to_hash
        HEADERS.each {|header| row_hash.delete header}
        header_hash = row_hash.compact
        raise  "Headers are missing" if(index == 0 && header_hash.empty?)
        header_hash.each do |header_key, value|
          if index == 0
            if header_key.present? && header_key.include?(user_suffix)
            else
             raise "Headers are not matching"
            end
          end
        end
        row.each do |header,value|
          if index == 0
            if header.present? && header.include?(user_suffix)
              user_name = header.split('_u').first
              user = User.find_or_create_by(name: user_name, cost_of_meal: value)
              user.save(validate:false)
            end
          else
            if row["Date"] == 'Total pending amount'
              if header.present? && header.include?(user_suffix)
                user_name = header.split('_u').first
                user = User.find_by(name: user_name)
                user.update(amount_to_be_paid: value)
                user.save(validate:false)
              end
            else
              date = Date.parse(row["Date"]) rescue next
              amount = row["Cost of Meal"]
              daily_invoice = Invoice.find_or_create_by(restaurant_name: "Imported Data", date: date, amount: amount)
              daily_invoice.save(validate: false)
              if header.present? && header.include?(user_suffix)
                user_name = header.split('_u').first
                user = User.find_by_name(user_name)
                had_lunch = value.present?? value : 0
                meal_expense = Expense.find_or_create_by(date: date,had_lunch: had_lunch, user_id: user.id, type: type, invoice_id: daily_invoice.id)
                meal_expense.save(validate: false)
              end
            end
          end
        end
      end
      return  "success"
    rescue Exception => e
      return e.message
    rescue Exception => e
      return e.message
    rescue
      return  "failure"

    end
  end
end

