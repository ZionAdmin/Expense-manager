require 'rails_helper'

RSpec.describe PaymentModesController, type: :controller do
  describe "GET #index" do
    before do
      @test_payment_mode=PaymentMode.create( payment_gateway: "cash")
      @test_payment_mode.save
      puts @test_payment_mode.inspect
    end

    it "will load the index page" do
      get :index
      expect(response.content_type).to eq "text/html"
      expect(response).to render_template(:index)
      expect(PaymentMode.count).to eq 4
    end
  end
  describe "GET #new" do
    it "will load the new page" do
      get :new
      expect(response.content_type).to eq "text/html"
      expect(response).to render_template(:new)
    end
  end
  describe "POST #create" do
    before do
      @test_payment_mode=PaymentMode.create(payment_gateway:"cash")
      @test_payment_mode.save
     puts @test_payment_mode.inspect
    end
    it "create the paymentmodes" do

    post :create ,payment_mode:{payment_gateway:"cash"}
    expect(PaymentMode.count).to eq 5
    expect(response.content_type).to eq "text/html"
    expect(response).to redirect_to payment_modes_path

      end
  end
  describe "GET show" do
    it "show one PaymentMode " do
      @test_payment_mode = PaymentMode.create( payment_gateway: "cash")
      get :show, id:@test_payment_mode.id
      expect(response.content_type).to eq "text/html"
      #assigns(:user).should eq([user])
      response.should render_template :show

    end
  end
  describe '#DELETE destroy' do
    it 'deletes a PaymentMode' do
      @test_payment_mode = PaymentMode.create( payment_gateway: "cash")
      delete :destroy,id:@test_payment_mode.id
      expect(response.content_type).to eq "text/html"
      expect(response).to redirect_to payment_modes_path
    end
  end
end
