json.extract! scheduled_tour, :id, :scheduled_date, :scheduled_time, :location, :tour_id, :account_user_id, :created_at, :updated_at
json.url scheduled_tour_url(scheduled_tour, format: :json)
