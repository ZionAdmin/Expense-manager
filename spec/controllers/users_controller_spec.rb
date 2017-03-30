require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #index" do
    before do
      @test_user=User.create( name: "p2", email: "p2@gmail.com", cost_of_meal: 60)
      @test_user.save
      puts @test_user.inspect
    end

    it "will load the index page" do
      get :index
      expect(response.content_type).to eq "text/html"
      expect(response).to render_template(:index)
      #expect(User.count).to eq 1
    end
    end

    describe "GET #new" do
      it "will load the new page" do
        get :new
        expect(response.content_type).to eq "text/html"
        expect(response).to render_template(:new)
      end
    end

  describe "POST create for User" do
    it "should create user with valid parameters" do
      post :create, user: { name: "p2", email: "p2@gmail.com" , cost_of_meal: "60"}
      expect(response.content_type).to eq "text/html"
      expect(User.count).to eq 1
      expect(response).to redirect_to users_path
      #expect(response).to render_template (:create)

    end
  end

  describe "GET show" do
    it "show one user " do
      user = User.create( name: "p2", email: "p2@gmail.com", cost_of_meal: 60)
      get :show, id:user.id
      expect(response.content_type).to eq "text/html"
      #assigns(:user).should eq([user])
      response.should render_template :show

    end
  end

  describe "GET edit" do
    it "edit one user" do
      user = User.create( name: "p2", email: "p2@gmail.com", cost_of_meal: 60)
      get :edit, id: user.id
      expect(response.content_type).to eq "text/html"
      #assigns(:user).should eq([user])
      response.should render_template :edit
    end
  end
  describe "put update" do
  it "update one user" do
    user = User.create( name: "p2", email: "p2@gmail.com", cost_of_meal: 60)
    put  :create, user: { name: "p2", email: "p2@gmail.com" , cost_of_meal: "60"}
    #put :update, id:user.id
    expect(response.content_type).to eq "text/html"
    expect(response).to redirect_to users_path
    #response.should render_template :edit
    #expect(response).to render_template(:edit)
  end
end
  describe '#DELETE destroy' do
    it 'deletes a User' do
      user = User.create( name: "p2", email: "p2@gmail.com", cost_of_meal: 60)
      delete :destroy,id:user.id
      expect(response.content_type).to eq "text/html"
      expect(response).to redirect_to users_path
    end
  end

end



