class WelcomeController < ApplicationController
  allow_unauthenticated_access only: :index

  def index
    @products = Product.all.order(created_at: :desc).limit(6)
    @total_products = Product.count rescue 0
    @total_orders = Order.count rescue 0
    @total_users = User.count rescue 0
  end
end
