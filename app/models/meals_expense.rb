class MealsExpense < Expense
  def week
    self.created_at.strftime("%U")
  end
  #
  # self.get_date_details
  # Finds all users with meal details
  #
  def self.get_date_details params
    users = User.all

    @from_date = params[:from_date]
    @to_date = params[:to_date]


    year = @from_date.split("-").first.to_i
    a = Date.parse(@from_date).cweek
    b = Date.parse(@to_date).cweek

    results = []

    (a..b).each_with_index do |i,k|

      date_array = []
      (1..7).each do |day|
        date_array << Date.commercial(year, i, day).to_date
        puts "11111#{date_array.inspect}"
      end

      u_amt_hash = {}

      user_costs = users.order(:name).pluck(:cost_of_meal)
      date_array.each do |date|
        next if @from_date.to_date > date
        next if @to_date.to_date < date
        @date_detail = []
        @date_detail1 = []
        @vardate = date

        @amount = DailyInvoice.where("daily_invoices.date = ? ", @vardate).pluck(:amount).first
        if @amount.nil?
          @amount = 0
        end
        u_amt_hash[date] = {}
        @date_detail << @vardate.to_date << @amount
         users.order(:name).each do |user|
              u_amt_hash[date][user.id] = 0
          @amount = DailyInvoice.where("daily_invoices.date = ? ", @vardate).pluck(:amount)
          if @amount.empty?
            @amount = 0
          end
          @had_lunch = Expense.where("date = ? AND user_id = ? ", @vardate, user.id).pluck(:had_lunch)
          if @had_lunch.empty?
            @had_lunch = 0
            u_amt_hash[date][user.id] = 0
          else
            @had_lunch = 1
            u_amt_hash[date][user.id] = user.cost_of_meal
          end
          @date_detail << @had_lunch
        end
        results << @date_detail
      end
      am ={}

      v = u_amt_hash.values

      v.each do |i|
        puts "i======#{i}"
          i.each do |k,v|
            am[k] ||= 0
            am[k] += v
          end
      end

      all_costs = am.values.uniq == [0] ? user_costs : am.values
      results << ['',''] + all_costs
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