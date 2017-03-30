require 'rails_helper'

RSpec.describe DailyInvoicesController, type: :controller do

  describe "GET #index" do

    before do
      @test_daily_invoice=DailyInvoice.create( restaurant_name: "Adigas", amount: "500", date: "2017-3-30",image: "")
      @test_expenses=Expense.create(id: 29,daily_invoice_id: @test_daily_invoice.id,date: "2017-3-30",had_lunch:"true",type: "MealsExpense",user_id: 2)
      @test_daily_invoice.save
      @test_expenses.save
      puts @test_daily_invoice.inspect
    end
    describe "with valid params" do

    it "will load the index page" do
      if (@test_daily_invoice == @test_expenses)
      get :index, daily_invoice_id: @test_daily_invoice.id ,expense_id: @test_expenses.id

      expect(response.content_type).to eq"text/html"
      expect(@test_daily_invoice).to eq(@test_expenses)
      expect(response).to render_template(:index)
        end
    end

    context "when daily_invoice_id and expense_id passed nil" do
      it "should redirect to index page" do
        get :index, daily_invoice_id: nil,expense_id: nil
        expect(response.content_type).to eq "text/html"
        #expect(response).to redirect_to root_path
        expect(response).to render_template(:index)
      end
    end
    end
  end

  describe "GET #new" do
    it "should load the new page" do
      get :new
      expect(response.content_type).to eq "text/html"
      expect(response).to render_template(:new)
    end
  end
  describe "GET #edit" do
    it "should load the edit page" do
      daily_invoice=DailyInvoice.create(restaurant_name: "Adigas", amount: "500", date: "2017-3-30",image: "")
      get :edit,id: daily_invoice.id
      expect(response.content_type).to eq "text/html"
      expect(response).to render_template(:edit)
    end
  end

  describe "GET #show" do
    before do
      @user=User.create(name:"navya",email: "navya@gmail.com",cost_of_meal: 65)
      @daily_invoice=DailyInvoice.create(restaurant_name: "Adigas", amount: "500", date: "2017-3-30",image: "")
      @expense = MealsExpense.create(daily_invoice_id: @daily_invoice.id,date: "2017-3-30",had_lunch:"true",user_id: @user.id)
      puts @expense.inspect
  end
      it "should go to show page" do
        get :show , id: @expense.id
        expect(response.content_type).to eq "text/html"
        expect(response).to render_template(:show)
        expect(Expense.type).to eq "MealsExpense"
      end
  end

  describe "POST #DailyInvoice" do

    before do
      @daily_invoice=DailyInvoice.create(restaurant_name: "Adigas", amount: "500", date: "2017-3-30")
      @user=User.create(name:"navya",email: "navya@gmail.com",cost_of_meal: 65)

    end

    context "When saved succesfully." do
    it "should redirect dailyinvoice_path and expenses_path" do
      #post :create,daily_invoice: {id: @daily_invoice.id,restaurant_name: "Adigas", amount: "500", date: "2017-3-30",image: ""}
      post :create,expense: {daily_invoice_id: @daily_invoice.id, date: "2017-3-30", had_lunch: "true", user_id: @user.id}

      expect(response.content_type).to eq "text/html"
      expect(response).to redirect_to daily_invoices_path

    end
    end

    # context "POST #DailyInvoice and Expenses." do
    #   it "should render to new page" do
    #     post :create,id: nil
    #
    #     expect(response.content_type).to eq "text/html"
    #     expect(response).to render_template (:new)
    #
    #   end
    # end

end
end


