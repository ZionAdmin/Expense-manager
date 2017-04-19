require 'rails_helper'

RSpec.describe UserPaymentsController, type: :controller do

  describe "GET#index" do
    before do
      @test_user_payment=UserPayment.create(id: @test_user_payment, user_id: 2, amount_paid: 45, date: "2017-4-2", comment: "Good",)
      @test_user_payment.save
      puts @test_user_payment.inspect
    end

    it "will load the index page" do
      get :index
      expect(response.content_type).to eq "text/html"
      expect(response).to render_template(:index)
      expect(UserPayment.count).to eq 0
    end
  end
  describe "GET#new" do
    before do
      @test_user = User.create(name:"navya",email:"navya@gmail.com",cost_of_meal:45)
      @test_payment_mode=PaymentMode.create(payment_gateway:"cash")
      @test_user_payment = UserPayment.create( user_id: @test_user.id, amount_paid: 45, date: "2017-4-2", comment: "Good",payment_mode_id: @test_payment_mode.id)
      puts @test_user_payment.inspect
    end

    it "will load the new page" do
      get :new, id: @test_user_payment.id
      expect(response.content_type).to eq "text/html"
      expect(response).to render_template(:new)
    end
  end
  describe "POST create" do
    before do
      @test_user = User.create(name:"navya",email:"navya@gmail.com",cost_of_meal:45)
      @test_payment_mode=PaymentMode.create(payment_gateway:"cash")
      @test_user_payment = UserPayment.create( user_id: @test_user.id, amount_paid: 45, date: "2017-4-2", comment: "Good",payment_mode_id:@test_payment_mode.id)
      puts @test_user_payment.inspect
    end
      it "creates a new user_payment" do
          post :create,id: @test_user_payment.id,user_payment: { user_id: @test_user.id, amount_paid: 45, date: "2017-4-2", comment: "Good",payment_mode_id: @test_payment_mode.id}
          expect(response.content_type).to eq "text/html"
          expect(response).to redirect_to user_payments_path

      end
  end

  describe "GET show" do
    before do
      @test_user = User.create(name:"navya",email:"navya@gmail.com",cost_of_meal:45)
      @test_payment_mode=PaymentMode.create(payment_gateway:"cash")
      @test_user_payment = UserPayment.create( user_id: @test_user.id, amount_paid: 45, date: "2017-4-2", comment: "Good",payment_mode_id:@test_payment_mode.id)
    end
    it "show one user_payment " do
      @test_user_payment = UserPayment.create( user_id: @test_user.id, amount_paid: 45, date: "2017-4-2", comment: "Good",payment_mode_id:@test_payment_mode.id)
      get :show, id:@test_user_payment.id
      expect(response.content_type).to eq "text/html"

      response.should render_template :show
    end
  end

  describe '#DELETE destroy' do
    before do
      @test_user = User.create(name:"navya",email:"navya@gmail.com",cost_of_meal:45)
      @test_payment_mode=PaymentMode.create(payment_gateway:"cash")
      @test_user_payment = UserPayment.create( user_id: @test_user.id, amount_paid: 45, date: "2017-4-2", comment: "Good",payment_mode_id:@test_payment_mode.id)
    end

      it 'deletes a UserPayment' do

        delete :destroy,id:@test_user_payment.id
        expect(response.content_type).to eq "text/html"
        expect(response).to redirect_to user_payments_path
      end

  end
  end