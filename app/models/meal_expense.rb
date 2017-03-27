class MealExpense < Expense

  def self.get_date_details params
    users=User.all
    meal_expenses=MealExpense.all

    @from_date=params[:from_date]
    @to_date=params[:to_date]

    year = @from_date.split("-").first.to_i
    a=Date.parse(@from_date).cweek
    b=Date.parse(@to_date).cweek

    calculation = {}
    week_array = ['', '']
    total_array=['', '']
    results = []
    totalamount=0

    (a..b).each do |i|
      weekamount=0

      date_array = []
      (1..7).each do |day|
        date_array << Date.commercial(year, i, day).to_date
        puts "11111#{date_array.inspect}"
      end

      date_array.each do |date|
        #weekamount=0
        puts "date is #{date.inspect}"
        next if @from_date.to_date > date
        next if @to_date.to_date < date
        @date_detail = []
        @vardate = date

        @amount = DailyInvoice.where("daily_invoices.date = ? ", @vardate).pluck(:amount).first
        if @amount.nil?
          @amount = 0
        end
        @date_detail << @vardate.to_date << @amount

        users.order(:name).each do |user|
          weekamount=0
          user.id
          @amount = DailyInvoice.where("daily_invoices.date = ? ", @vardate).pluck(:amount)
          if @amount.empty?
            @amount = 0
          end
          @had_lunch = Expense.where("date = ? AND user_id = ? ", @vardate, user.id).pluck(:had_lunch)
          if @had_lunch.empty?
            @had_lunch = 0
          else
            @had_lunch = 1
            calculation[user.id] ||= {}
            calculation[user.id][:week_amount] = user.cost_of_meal
          end
          @date_detail << @had_lunch
        end

        puts"calculation===>#{calculation.inspect}"
        results << @date_detail

      end
      #results << week_array

      (calculation).each do |key, value|
        (value).each do |key1, value1|
          #week_array[key1] = (value1)
          week_array << value1
          puts "week amount is #{week_array}"
          total_array=totalamount+value1
          total_array << totalamount
          puts "total amount is #{totalamount}"
        end
      end
      results << week_array
    end

    puts "results is #{results.inspect}"

    users = User.order(:name)

    headers = ["Date", "Amount"]

    costofmeal = ['', '']
    users.each do |user|
      headers << user.name
      costofmeal << user.cost_of_meal
    end

    CSV.generate(headers: true) do |csv|
      csv << headers
      csv << costofmeal

      results.each do |result|

        csv << result
      end
    end

  end

end