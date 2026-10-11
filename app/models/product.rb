class Product < ApplicationRecord
  def self.search(query)
    query = query.to_s.strip
    return all if query.blank?

    where("LOWER(name) LIKE :term OR LOWER(categorie) LIKE :term", term: "%#{query.downcase}%")
  end
end
