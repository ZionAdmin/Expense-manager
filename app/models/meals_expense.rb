class MealsExpense < Expense

  def self.get_date_details params
    users=User.all
    meal_expenses=MealsExpense.all

    @from_date=params[:from_date]
    @to_date=params[:to_date]

    year = @from_date.split("-").first.to_i
    a=Date.parse(@from_date).cweek
    b=Date.parse(@to_date).cweek

    calculation = {}
    week_array = ['','']
    total_array=['','']
    results = []

    (a..b).each do |i|

      date_array = []
      (1..7).each do |day|
        date_array << Date.commercial(year, i, day).to_date
        puts "11111#{date_array.inspect}"
      end

      date_array.each do |date|

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
        results << @date_detail
      end
      results << week_array


      (calculation).each do |key,value|
        (value).each do |key1,value1|

         # week_array << value1

          puts "week amount is #{week_array}"

          # total_array=totalamount+value1
          # total_array << totalamount
          # puts "total amount is #{total_amount}"
        end
      end
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

  def self.import params
    @file = params[:file].read
  end

  def self.import_result params
    rowarray = Array.new
    @file = params[:file].read

    csv = CSV.parse(@file, headers: false, :col_sep => ",")

    csv.each_with_index do |row, index|
      #puts"row===>#{row}"
      #puts "index===>#{index}"
      users_array = []
      cost_of_meal = nil
      if index == 0
        users = row.compact.select{|obj| obj.include?("_u")}
        @users = users.map { |x| x.to_s.split('_u') }.flatten
        puts "@users =====>#{@users}"
        @users.each do |user|
          users = User.create(name: user)
            users.save(validate:false)
       end
      end
     if index == 1
       #puts "row=========>#{row}"
        #cost_of_meal = row.shift
        #puts "cost_of_meal======>#{cost_of_meal}"  
        
        cost_of_meals = row.compact.select{|obj1| obj1.include?("_s")}
        #puts "cost_of_meal====>#{cost_of_meal}"
        @costofmeal = cost_of_meals.map {|s| s.split('_s')}.flatten
        #puts "@costofmeal ====>#{@costofmeal}"
        
        results = @users.zip(@costofmeal)
        puts "results======>#{results}"
        
        results.each do |result|
          users = User.create(name:result,cost_of_meal: result)
          users.save
          end
        end
     
    
  end
     

    # rowarray << row
    # @rowdisp = rowarray
    #
    # @rowdisp[0,1].each do |line|
    #   users = line.compact.select{|obj| obj.include?("_u")}
    #   #puts "$$$$$$$$$$#{line.inspect}"
    #   # var = line.group_by(&:itself).map { |k, v| k }
    #   # puts "@@@@@@@@@@@@@@@#{var.inspect}"
    #   users = users.map { |x| x.to_s.split('_u') }.flatten
    #   # users.each do |user|
    #   #   @users = User.create(name: user)
    #   #   @users.save(validate:false)
    #   # end
    #
    #
    #   # #if var1.to_s.end_with?("_u")
    #   #    @first_row = var1.values_at(2..23)
    #   #       puts "$$$$$$$$$$$$$$$#{@first_row}"
		#users.each do |user|
    #   #   @users = User.create(name: @first_row)
    #   #   @users.save
		#end
    # end

    #end

    end
  end










