require 'rails_helper'

RSpec.describe DailyInvoicesController, type: :controller do

  describe "GET #index" do

    before do
      @test_daily_invoice=DailyInvoice.create( restaurant_name: "Adigas", amount: "500", date: "2017-3-30",image: fixture_file_upload('app/assets/images/index1.JPEG'))
      @test_expenses=Expense.create(daily_invoice_id: @test_daily_invoice.id,date: "2017-3-30",had_lunch:"true",type: "MealsExpense",user_id: 2)
      @test_daily_invoice.save
      @test_expenses.save
      puts @test_expenses.inspect
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
      daily_invoice=DailyInvoice.create(restaurant_name: "Adigas", amount: "500", date: "2017-3-30",image: fixture_file_upload('app/assets/images/index1.JPEG'))
      get :edit,id: daily_invoice.id
      expect(response.content_type).to eq "text/html"
      expect(response).to render_template(:edit)
    end
  end

  describe "GET #show" do
    before do
      @user=User.create(name:"navya",email: "navya@gmail.com",cost_of_meal: 65)
      @daily_invoice=DailyInvoice.create(restaurant_name: "Adigas", amount: "500", date: "2017-3-30",deleted_at: "2")
      @expense = MealsExpense.create(daily_invoice_id: @daily_invoice.id,date: "2017-3-30",had_lunch:"true",user_id: @user.id)
      puts @expense.inspect
    end
      it "should go to show page" do
        get :show , id: @daily_invoice.id
        expect(response.content_type).to eq "text/html"
        expect(response).to render_template(:show)
        expect(@expense.type).to eq "MealsExpense"
      end
  end

  describe "POST #DailyInvoice" do
    before do
      @user=User.create(name:"navya",email: "navya@gmail.com",cost_of_meal: 65)
      puts @user.inspect
      @daily_invoice=DailyInvoice.new(:restaurant_name => 'Adigas', :amount => 500,:date => '2017-3-30',image: fixture_file_upload('app/assets/images/index1.JPEG'))
      @expense=Expense.new(:date =>"04/04/2017",:had_lunch =>"true",:user_id => @user.id,:daily_invoice_id => @daily_invoice.id,:type =>"MealsExpense")

      @daily_invoice.save
      @expense.save
      # puts @daily_invoice.inspect
       puts @expense.inspect
    end

    it "should redirect dailyinvoice_path and expenses_path" do
      post :create,daily_invoice: {restaurant_name:  "Adigas", amount:  "500", date:  "2017-3-30",image: fixture_file_upload('app/assets/images/index1.JPEG'), :expense => {:user_ids =>[@user.id], date: "04/04/2017" , had_lunch: "true", type:"MealsExpense"}}
      puts @daily_invoice.inspect

      expect(response.content_type).to eq "text/html"
      expect(Expense.count).to eq 1
      expect(DailyInvoice.count).to eq 2
      #assigns(:expense).should eq(@expense)
      expect(response).to redirect_to daily_invoices_path

    end
    end

  describe "put #update" do
    before do
      @user=User.create(name:"navya",email: "navya@gmail.com",cost_of_meal: 65)
      puts @user.inspect
      @daily_invoice=DailyInvoice.new(:restaurant_name => 'Adigas', :amount => 500,:date => '2017-3-30',image: fixture_file_upload('app/assets/images/index1.JPEG'))
      @expense=Expense.new(:date =>"04/04/2017",:had_lunch =>"true",:user_id => @user.id,:daily_invoice_id => @daily_invoice.id,:type =>"MealsExpense")
    end
      it "update one dailyinvoice" do
      @daily_invoice=DailyInvoice.new(:restaurant_name => 'Adigas', :amount => 500,:date => '2017-3-30',image: fixture_file_upload('app/assets/images/index1.JPEG') )
      put  :create,daily_invoice: {restaurant_name:  "Adigas", amount:  "500", date:  "2017-3-30",image: fixture_file_upload('app/assets/images/index1.JPEG'), :expense => {:user_ids =>[@user.id], date: "04/04/2017" , had_lunch: "true", type:"MealsExpense"}}
      expect(response.content_type).to eq "text/html"
      expect(response).to redirect_to daily_invoices_path
    end
  end

    describe '#DELETE destroy' do
      before do
        @daily_invoice = DailyInvoice.create(restaurant_name: "Adigas", amount: "500", date: "2017-3-30",image: fixture_file_upload('app/assets/images/index1.JPEG'))
        @meal_expense= MealsExpense.create(daily_invoice_id: @daily_invoice.id,date: "2017-3-30",had_lunch:"true",user_id: 2)
        puts @meal_expense.inspect
      end

      it 'deletes a dailyinvoice' do
         delete :destroy,id: @daily_invoice.id
         change(DailyInvoice, :count).by(-1)
        expect(response.content_type).to eq "text/html"
        expect(response).to redirect_to daily_invoices_path
        #expect(@daily_invoice.deleted_at).not_to eq nil
        #expect(DailyInvoice.count).by(-1)
        #expect(response.status).to eq 200

        # it "redirects to dailyinvoice#index" do
        #   delete :destroy, id: @daily_invoice.id
        #   expect(response.content_type).to eq "text/html"
        #   expect(response).to redirect_to daily_invoices_path
        # end
      end
    end

  describe '#POST DailyDetail' do
    before do
      @user = User.create(name:"navya",email: "navya@gmail.com",cost_of_meal: 65)
      @daily_invoice = DailyInvoice.create(restaurant_name: "Adigas", amount: "500", date: "2017-03-14")
      @expense = Expense.create(daily_invoice_id: @daily_invoice.id,date: "2017-03-14",had_lunch:"true",user_id: @user.id)
        puts @daily_invoice.inspect
    end
    context "when date param is present" do
      it "create a  valid record" do
        xhr :post, :daily_details,:id => @daily_invoice.id ,controller=>"daily_invoices", params:  {"date"=>"2017-03-14"}
        expect(response.content_type).to eq "text/html"
        #expect(daily_details).to eq "daily_details"
        #expect(response).to redirect_to daily_details_path
        expect(response).to render_template(:daily_details)
      end
    end
  end
end


