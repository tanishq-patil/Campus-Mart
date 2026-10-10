
# Clear old test dummy records if any
Product.where(name: ["ggg", "dsfs"]).destroy_all

products = [
  { name: "Calculus & Analytical Geometry 9th Ed", categorie: "Textbooks", price: 45.00 },
  { name: "Sony WH-1000XM4 Noise Canceling Headphones", categorie: "Electronics", price: 180.00 },
  { name: "Compact Dorm Mini Fridge (45L)", categorie: "Dorm & Furniture", price: 65.50 },
  { name: "Ergonomic Mesh Study Chair", categorie: "Dorm & Furniture", price: 35.00 },
  { name: "TI-84 Plus CE Graphing Calculator", categorie: "Electronics", price: 75.00 },
  { name: "Campus Varsity Hoodie (Size M)", categorie: "Apparel & Accessories", price: 25.00 },
  { name: "Wilson NCAA Official Basketball", categorie: "Sports & Fitness", price: 18.00 }
]

products.each do |prod|
  Product.find_or_create_by!(name: prod[:name]) do |p|
    p.categorie = prod[:categorie]
    p.price = prod[:price]
  end
end

puts "Seeded #{Product.count} products successfully!"
