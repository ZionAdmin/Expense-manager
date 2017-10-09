  Rails.application.routes.draw do
  resources :custom_expense_types
     root "invoices#index"
     resources :users
     resources :expenses do
       collection do
         post :imports
       end
     end
     resources :meals_expenses, controller: "meals_expenses", type: "MealsExpense" do
       collection do
         get :export
       end
     end
     resources :fruits_expenses, controller: "expenses", type: "FruitsExpense"
     resources :snaks_expenses, controller: "expenses", type: "SnaksExpense"
     resources :invoices

     match "invoice_params" => "invoices#invoice_params", :as => :invoice_params, :via => [:get, :post]
     match "previous_record" => "invoices#previous_record", :as => :previous_record, :via => [:get]
     match "daily_details" => "invoices#daily_details", :as => :daily_details, :via => [:get, :post]
     match "/"=> "expense_manager#dashboard",:via => [:get, :post]
     match "user_month_details" => "users#user_month_details",  :via => [:get, :post]
     match "month_info" => "users#month_info", :via => [:get, :post]

     resources :user_payments
     resources :payment_modes

    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  end
