json.array!(@banners) do |banner|
  json.extract! banner, :id, :web_link, :image
  json.url banner_url(banner, format: :json)
end
