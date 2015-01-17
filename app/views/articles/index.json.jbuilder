json.array!(@articles) do |article|
  json.extract! article, :id, :name, :description, :shippable
  json.url article_url(article, format: :json)
end
