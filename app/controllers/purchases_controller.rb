# frozen_string_literal: true

class PurchasesController < ApplicationController
  before_action :set_purchase, only: %i[show edit update destroy]

  PurchaseCategoryBreakdown = Struct.new(:name, :purchase_cost)

  # GET /purchases
  # GET /purchases.json
  def index
    @year = params.fetch(:year, Date.today.year)
    @month = params.fetch(:month, Date.today.month)
    query = "#{@year}-#{@month}-01"
    @purchases = Purchase.all
                         .order(:date)
                         .where("DATE_TRUNC('month', date) = ?", query)
    @total_purchases = @purchases.inject(0) do |sum, purchase|
      sum + purchase.unit_cost * purchase.quantity
    end.round(2)
    category_breakdown
  end

  # GET /purchases/1
  # GET /purchases/1.json
  def show; end

  # GET /purchases/new
  def new
    @purchase = Purchase.new
  end

  # GET /purchases/1/edit
  def edit; end

  # POST /purchases
  # POST /purchases.json
  def create
    @purchase = Purchase.new(purchase_params)

    respond_to do |format|
      if @purchase.save
        format.html { redirect_to @purchase, notice: 'Purchase was successfully created.' }
        format.json { render :show, status: :created, location: @purchase }
      else
        format.html { render :new }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /purchases/1
  # PATCH/PUT /purchases/1.json
  def update
    respond_to do |format|
      if @purchase.update(purchase_params)
        format.html { redirect_to @purchase, notice: 'Purchase was successfully updated.' }
        format.json { render :show, status: :ok, location: @purchase }
      else
        format.html { render :edit }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchases/1
  # DELETE /purchases/1.json
  def destroy
    @purchase.destroy
    respond_to do |format|
      format.html { redirect_to purchases_url, notice: 'Purchase was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_purchase
    @purchase = Purchase.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  # Converts the total cost to a unit cost, ready to send to the model.
  def purchase_params
    result = params.require(:purchase).permit(:date, :retailer_id, :item_id, :quantity, :total_cost)
    total = result.delete(:total_cost)
    result[:unit_cost] = BigDecimal(total) / Integer(result.fetch(:quantity))
    result
  end

  def category_breakdown
    purchase_categories = @purchases.map do |purchase|
      [purchase.item.category.name,
       purchase.quantity * purchase.unit_cost]
    end
    grouped = purchase_categories.group_by(&:first)
    @category_breakdown = grouped.map do |category, pairs|
      category_total = pairs.inject(0) { |sum, pair| sum + pair.last }
      PurchaseCategoryBreakdown.new(category, category_total.round(2))
    end
  end
end
