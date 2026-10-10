require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
  end

  test "should get index" do
    get products_url
    assert_response :success
  end

  test "should filter products by search query" do
    Product.create!(name: "Laptop", categorie: "Electronics", price: 999.99)
    Product.create!(name: "Book", categorie: "Education", price: 19.99)

    get products_url, params: { q: "lap" }

    assert_response :success
    assert_select ".product-card", 1
    assert_select ".product-card", /Laptop/
  end

  test "should get new" do
    get new_product_url
    assert_response :success
  end

  test "should create product" do
    assert_difference("Product.count") do
      post products_url, params: { product: { categorie: @product.categorie, name: @product.name, price: @product.price } }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should show product" do
    get product_url(@product)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success
  end

  test "should update product" do
    patch product_url(@product), params: { product: { categorie: @product.categorie, name: @product.name, price: @product.price } }
    assert_redirected_to product_url(@product)
  end

  test "should destroy product" do
    assert_difference("Product.count", -1) do
      delete product_url(@product)
    end

    assert_redirected_to products_url
  end
end
