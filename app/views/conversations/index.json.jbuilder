json.array!(@conversations) do |conversation|
  json.extract! conversation, :id, :user_1_id, :user_2_id
  json.url conversation_url(conversation, format: :json)
end
