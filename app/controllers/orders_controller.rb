class OrdersController < ApplicationController
  allow_unauthenticated_access only: %i[ index show new create ]
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    @orders = Order.all.includes(:user, line_items: :product).order(created_at: :desc)
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
    @products = Product.all.order(:name)

    if params[:product_id].present?
      @order.line_items.build(product_id: params[:product_id], quantity: params[:quantity].presence || 1)
    else
      @order.line_items.build(quantity: 1)
    end
  end

  # GET /orders/1/edit
  def edit
    @products = Product.all.order(:name)
    @order.line_items.build(quantity: 1) if @order.line_items.empty?
  end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_attributes)
    
    # Assign user: Current.user > specified user_id > default student user
    if Current.user
      @order.user = Current.user
    elsif @order.user_id.blank?
      @order.user = User.first || User.create!(
        name: "Campus Student",
        email_address: "student@campus.edu",
        password: "password123"
      )
    end

    # Handle direct single product parameters if provided
    if params[:order][:product_id].present? && @order.line_items.empty?
      @order.line_items.build(
        product_id: params[:order][:product_id],
        quantity: params[:order][:quantity].presence || 1
      )
    end

    @order.calculate_total

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: "Order ##{@order.id} was successfully placed." }
        format.json { render :show, status: :created, location: @order }
      else
        @products = Product.all.order(:name)
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_attributes)
        @order.calculate_total
        @order.save
        format.html { redirect_to @order, notice: "Order ##{@order.id} was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @order }
      else
        @products = Product.all.order(:name)
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy!

    respond_to do |format|
      format.html { redirect_to orders_path, notice: "Order was successfully cancelled.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_order
    @order = Order.includes(:user, line_items: :product).find(params[:id])
  end

  def order_params
    params.require(:order).permit(
      :user_id,
      :total,
      :product_id,
      :quantity,
      line_items_attributes: [ :id, :product_id, :quantity, :_destroy ]
    )
  end

  def order_attributes
    order_params.except(:product_id, :quantity)
  end
end
