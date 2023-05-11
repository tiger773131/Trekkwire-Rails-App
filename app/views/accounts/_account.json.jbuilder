json.cache! [account] do
  json.extract! account, :id, :name, :personal, :description, :owner_id, :created_at, :updated_at
  json.account_users do
    json.array! account.account_users, :id, :user_id
  end
end
