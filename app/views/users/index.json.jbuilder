json.array!(@users) do |user|
  json.extract! user, :name, :email, :token, :last_login
  json.url user_url(user, format: :json)
end