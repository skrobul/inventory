# frozen_string_literal: true

class AllocationsController < ApplicationController
  before_action :set_allocation, only: %i[show edit update destroy]

  AllocationCategoryBreakdown = Struct.new(:name, :used_cost)

  # GET /allocations
  # GET /allocations.json
  def index
    @year = params.fetch(:year, Date.today.year)
    @month = params.fetch(:month, Date.today.month)
    query = "#{@year}-#{@month}-01"
    @allocations = Allocation.all
                             .order(:date)
                             .where("DATE_TRUNC('month', date) = ?", query)
    @total_allocations = @allocations.inject(0) do |sum, allocation|
      sum + allocation.purchase.unit_cost * allocation.quantity
    end.round(2)
    category_breakdown
  end

  # GET /allocations/1
  # GET /allocations/1.json
  def show; end

  # GET /allocations/new
  def new
    @allocation = Allocation.new
  end

  # GET /allocations/1/edit
  def edit; end

  # POST /allocations
  # POST /allocations.json
  def create
    allocation_result = Allocation.allocate_items(allocation_params)

    respond_to do |format|
      if allocation_result.success? && allocation_result.allocations.map(&:save).all?
        format.html { redirect_to allocations_url, notice: 'Allocations were successfully created.' }
      else
        @allocation = Allocation.new
        @allocation.errors.add(:quantity, allocation_result.error_message)
        format.html { render :new }
      end
      #   if @allocation.save
      #     format.html { redirect_to @allocation, notice: 'Allocation was successfully created.' }
      #     format.json { render :show, status: :created, location: @allocation }
      #   else
      #     format.html { render :new }
      #     format.json { render json: @allocation.errors, status: :unprocessable_entity }
      #   end
    end
  end

  # PATCH/PUT /allocations/1
  # PATCH/PUT /allocations/1.json
  def update
    respond_to do |format|
      if @allocation.update(allocation_params)
        format.html { redirect_to @allocation, notice: 'Allocation was successfully updated.' }
        format.json { render :show, status: :ok, location: @allocation }
      else
        format.html { render :edit }
        format.json { render json: @allocation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /allocations/1
  # DELETE /allocations/1.json
  def destroy
    @allocation.destroy
    respond_to do |format|
      format.html { redirect_to allocations_url, notice: 'Allocation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_allocation
    @allocation = Allocation.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def allocation_params
    result = params.require(:allocation).permit(:date, :quantity)
    item_id = params.dig(:item, :id)
    result[:item_id] = item_id
    result
  end

  def category_breakdown
    allocation_categories = @allocations.map do |allocation|
      [allocation.purchase.item.category.name,
       allocation.purchase.unit_cost * allocation.quantity]
    end
    grouped = allocation_categories.group_by(&:first)
    @category_breakdown = grouped.map do |category, pairs|
      category_total = pairs.inject(0) { |sum, pair| sum + pair.last }
      AllocationCategoryBreakdown.new(category, category_total.round(2))
    end
  end
end
