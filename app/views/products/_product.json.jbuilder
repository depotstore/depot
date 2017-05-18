json.extract! product, :id, :title, :description, :image_url, :price, :locale,
:created_at, :updated_at
json.url product_url(product, format: :json)
