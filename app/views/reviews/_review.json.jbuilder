json.extract! review, :id, :author, :rating, :text, :created_at, :updated_at
json.url product_review_url(@product, review, format: :json)
