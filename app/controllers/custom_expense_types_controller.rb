class CustomExpenseTypesController < ApplicationController
  before_action :set_custom_expense_type, only: [:show, :edit, :update, :destroy]

  def index
    @custom_expense_types = CustomExpenseType.all
  end

  def show
  end

  def new
    @custom_expense_type = CustomExpenseType.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
  end

  def create
    @custom_expense_type = CustomExpenseType.new(custom_expense_type_params)
    @custom_expense_type_all = CustomExpenseType.all

    respond_to do |format|
      if @custom_expense_type.save
        @custom_expense_type_last = @custom_expense_type_all.last
        format.js
      else
        format.html { render :new }
        format.json { render json: @custom_expense_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @custom_expense_type.update(custom_expense_type_params)
        format.html { redirect_to @custom_expense_type, notice: 'Custom expense type was successfully updated.' }
        format.json { render :show, status: :ok, location: @custom_expense_type }
      else
        format.html { render :edit }
        format.json { render json: @custom_expense_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @custom_expense_type.destroy
    respond_to do |format|
      format.html { redirect_to custom_expense_types_url, notice: 'Custom expense type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_custom_expense_type
      @custom_expense_type = CustomExpenseType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def custom_expense_type_params
      params.require(:custom_expense_type).permit(:name)
    end
end
