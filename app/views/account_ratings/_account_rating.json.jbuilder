json.extract! account_rating, :id, :target_account_id, :source_account_id, :title, :review, :rating, :created_at, :updated_at
json.url account_rating_url(account_rating, format: :json)
