class AllocationsController < ApplicationController
  before_action :set_allocation, only: [:show, :edit, :update, :destroy]

  # GET /allocations
  # GET /allocations.json
  def index
    @allocations = Allocation.all
  end

  # GET /allocations/1
  # GET /allocations/1.json
  def show
  end

  # GET /allocations/new
  def new
    @allocation = Allocation.new
  end

  # GET /allocations/1/edit
  def edit
  end

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
end
