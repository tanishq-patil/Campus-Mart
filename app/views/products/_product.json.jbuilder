json.extract! product, :id, :name, :categorie, :price, :created_at, :updated_at
json.url product_url(product, format: :json)
